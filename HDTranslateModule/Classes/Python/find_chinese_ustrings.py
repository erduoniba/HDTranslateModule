import sys
import re
import json
import os
from google.cloud import translate_v2 as translate
from concurrent.futures import ThreadPoolExecutor

completed_translations = 0
translations = 0


# 使用google进行私钥翻译：pip install google-cloud-translate
def translate_text(text, src_lang='zh-CN', dest_lang='en'):
    translate_client = translate.Client()
    result = translate_client.translate(
        text, target_language=dest_lang, source_language=src_lang)
    return result['translatedText']


# 翻译指令
def translate_worker(value):
    if adjustChinese(value):
        translated_text = translate_text(value)
        if translated_text:
            # 使用global关键字指示我们要使用和修改全局变量
            global completed_translations
            global translations

            completed_translations += 1
            # print(value+"翻译成功")
            print("翻译进度：", completed_translations, "/", translations)
            return (value, translated_text)
        else:
            print(value+"翻译失败")
    return None


# 十六进制转成中文，并且中英文翻译
def otool_hex_to_str(otool_output):
    # 提取十六进制数据
    hex_data = re.findall(r'\t([0-9a-fA-F ]+)', otool_output)
    # print("hex_data", hex_data)

    # 将十六进制数据连接成一个字符串
    hex_str = ''.join(hex_data).replace(' ', '')
    # print("hex_str", hex_str)

    # 将十六进制数据转换为字节串
    byte_data = bytes.fromhex(hex_str)
    # print("byte_data", byte_data)

    # 尝试以UTF-16编码解码字节串
    decoded_str = byte_data.decode('utf-16', errors='ignore')
    # print("decoded_str", decoded_str)

    # 使用正则表达式匹配所有非空字符
    all_strings = re.findall(r'[^\x00]+', decoded_str)
    # print("all_strings", all_strings)

    # all_strings可能有非中文，请过滤掉
    output_datas = []
    output_translate_datas = []
    total_texts = len(all_strings)

    global translations
    translations = len(all_strings)

   # 这个修改后的代码使用了ThreadPoolExecutor来实现多线程翻译。translate_worker函数是一个新的辅助函数，
   # 它接受一个字符串并尝试翻译。otool_hex_to_str函数中的循环被替换为一个executor.map调用，
   # 它将translate_worker应用于all_strings中的每个元素。这将并行执行翻译任务，从而加快速度。
    with ThreadPoolExecutor() as executor:
        results = list(executor.map(translate_worker, all_strings))

    for result in results:
        if result is not None:
            output_datas.append(result[0])
            output_translate_datas.append(result[1])

    return output_datas, output_translate_datas


# 判断是否包含中文
def adjustChinese(value):
    if value:
        if len(value) > 0:
            for s in value:
                if u'\u4e00' <= s <= u'\u9fff':
                    return True
    return False


# 将otool命令输出的内容写入文件
def otool_to_file(macho_file, ustring_file):
    # 将otool命令输出的内容写入文件
    os.system(f"otool  -X -s __TEXT __ustring  {macho_file} > {ustring_file}")


# 读取ustring_file文件，并将其json数组，然后翻译，返回原始数据和翻译后数据
def read_ustring_file(ustring_file):
    with open(ustring_file, 'r') as f:
        otool_output = f.read()
    return otool_hex_to_str(otool_output)


# 将翻译后的all_strings、all_translate_strings写入file_path、file_translate_path文件
def write_ustring_local_file(file_path, file_translate_path, all_strings, all_translate_strings):
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(all_strings, f, ensure_ascii=False, indent=2)
    with open(file_translate_path, 'w', encoding='utf-8') as f:
        json.dump(all_translate_strings, f, ensure_ascii=False, indent=2)


# 读取file_path、file_translate_path文件，并将其json数组以 如下格式写入ustring_output.json文件
def read_ustring_local_file(file_path, file_translate_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        file_path_data = json.load(f)
    with open(file_translate_path, 'r', encoding='utf-8') as f:
        file_translate_path_data = json.load(f)
    return file_path_data, file_translate_path_data


# 将all_strings、all_translate_strings 以 "中文"="English" 的形式写入file_final_path.json文件
def write_final_ustring_local_file(file_final_path, all_strings, all_translate_strings):
    with open(file_final_path, 'w', encoding='utf-8') as f:
        for index in range(len(all_strings)):
            # 使用原始字符串表示法，repr()，以便在all_translate_strings中的\n不被转义
            # 使用了repr()函数来获取all_strings[index]和all_translate_strings[index]的可打印表示。
            # 这将确保\n不被转义。但是，repr()函数还会在字符串的开头和结尾添加额外的单引号。
            # 为了避免这个问题，您可以在format()函数中使用切片操作来去掉这些额外的单引号。
            f.write(r'"{}" = "{}";'.format(
                repr(all_strings[index])[1:-1], repr(all_translate_strings[index])[1:-1]) + '\n')


# python3 find_chinese_utrings.py HDFindStringDemo
if __name__ == '__main__':
    print("start")

    macho_file = sys.argv[1]
    ustring_file = f"{macho_file}_ustring.txt"
    output_file = f"{macho_file}_ustring_output.json"
    file_translate_path = f"{macho_file}_ustring_output_translate.json"
    file_final_path = f"{macho_file}_ustring_output_final.json"

    ##########  翻译+读写全流程 ##########
    # 翻译+读写全流程step1：将otool命令输出的内容写入文件
    otool_to_file(macho_file, ustring_file)

    # # 翻译+读写全流程step2：读取ustring_file文件，并将其json数组，然后翻译，返回原始数据和翻译后数据
    all_strings, all_translate_strings = read_ustring_file(ustring_file)

    # # 翻译+读写全流程step3:将翻译后的all_strings、all_translate_strings写入output_file、file_translate_path文件
    write_ustring_local_file(
        output_file, file_translate_path, all_strings, all_translate_strings)

    # # 翻译+读写全流程step4：将all_strings、all_translate_strings 以 "中文"="English" 的形式写入file_final_path.json文件
    write_final_ustring_local_file(
        file_final_path, all_strings, all_translate_strings)
    ##########  翻译+读写全流程 ##########

    ##########  本地文件读取翻译 ##########
    # 本地文件读取step1 读取output_file、file_translate_path文件，并将其json数组以 如下格式写入ustring_output.json文件
    # all_strings, all_translate_strings = read_ustring_local_file(
        # output_file, file_translate_path)

    # 本地文件读取step2：将all_strings、all_translate_strings 以 "中文"="English" 的形式写入file_final_path.json文件
    # write_final_ustring_local_file(
        # file_final_path, all_strings, all_translate_strings)
    ##########  本地文件读取翻译 ##########

    print("end")
