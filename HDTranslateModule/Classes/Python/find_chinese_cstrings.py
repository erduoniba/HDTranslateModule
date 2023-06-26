import re
import sys
from urllib import parse
import json
import os
from google.cloud import translate_v2 as translate
from concurrent.futures import ThreadPoolExecutor


# 已经翻译好的个数
completed_translations = 0
# 总的需要翻译的个数
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


# 八进制转成十六进制
def octal_to_hex(octal_number):
    # 八进制转成十进制数据
    decimal_number = int(octal_number, 8)
    # Unicode 字符串按位运算
    valide_number = decimal_number & 0xFF
    # 转成可用的十六进制数据
    hex_number = hex(valide_number)[1:]
    return hex_number


# 十六进制转成中文
def hex_to_chinese(x):
    y = x.encode('unicode_escape')
    z = y.decode('utf-8').replace('\\x', '%')
    # 兼容多余的 \\ 符号
    z = z.replace('\\', '')
    un = parse.unquote(z)
    return un


# 处理一行数据，找到中文的特殊字符，转成中文
def convert_octal_to_hex(input_str):
    octal_numbers = re.findall(r'\\37777777\d{3}', input_str)
    # print(octal_numbers)
    for octal_number in octal_numbers:
        octal_number = octal_number[1:]  # 去掉开头的反斜杠
        # print("octal_number", octal_number)

        # 八进制转成十进制数据，并且转成可用的十六进制数据
        hex_number = octal_to_hex(octal_number)

        hex_str = "\\" + hex_number
        # 这里是做替换操作，避免丢失空格
        input_str = input_str.replace("\\" + octal_number, hex_str)
    return input_str


# 处理一行数据，找到中文的特殊字符，转成中文
def dispose_line(input_str):
    # 1. 从 "Swift \37777777744\37777777670\37777777655" 找到 "\37777777744\37777777670\37777777655"
    start_index = input_str.find(r"\37777777")
    if start_index < 0:
        return None
    octal_str = input_str[start_index:]
    # print("octal_str", octal_str)

    # 2. 将 "\37777777744\37777777670\37777777655" 作为八进制，转成 十六进制
    output_str = convert_octal_to_hex(input_str)
    # print("output_str", output_str)
    return hex_to_chinese(output_str)


# 判断value是否是中文
def adjustChinese(value):
    if value:
        if len(value) > 0:
            for s in value:
                if u'\u4e00' <= s <= u'\u9fff':
                    return True
    return False


# 使用otool命令，将二进制文件中的__cstring段落，导出到文件中
def otool_to_file(macho_file, cstring_file):
    os.system(
        f"otool -V -X -s __TEXT __cstring {macho_file} > {cstring_file}")


# 从文件中读取数据，进行翻译
def translate_cstring(cstring_file):
    all_strings = []
    with open(cstring_file, 'r') as f:
        for line in f:
            # 去掉换行符
            line = line.strip()
            value = dispose_line(line)

            if adjustChinese(value):
                all_strings.append(value)

    global translations
    translations = len(all_strings)

    # 这个修改后的代码使用了ThreadPoolExecutor来实现多线程翻译。translate_worker函数是一个新的辅助函数，
    # 它接受一个字符串并尝试翻译。otool_hex_to_str函数中的循环被替换为一个executor.map调用，
    # 它将translate_worker应用于all_strings中的每个元素。这将并行执行翻译任务，从而加快速度。
    with ThreadPoolExecutor() as executor:
        results = list(executor.map(translate_worker, all_strings))

    output_datas = []
    output_translate_datas = []
    for result in results:
        if result is not None:
            output_datas.append(result[0])
            output_translate_datas.append(result[1])

    return output_datas, output_translate_datas


# 将翻译好的数据，写入到文件中
def write_to_file(output_data, output_file_path):
    with open(output_file_path, 'w', encoding='utf-8') as f:
        json.dump(output_data, f, ensure_ascii=False, indent=2)


# 将翻译后的all_strings、all_translate_strings写入output_file、file_translate_path文件
def write_ustring_local_file(output_file, file_translate_path, all_strings, all_translate_strings):
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(all_strings, f, ensure_ascii=False, indent=2)
    with open(file_translate_path, 'w', encoding='utf-8') as f:
        json.dump(all_translate_strings, f, ensure_ascii=False, indent=2)


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


# 读取file_path、file_translate_path文件，并将其json数组以 如下格式写入ustring_output.json文件
def read_ustring_local_file(file_path, file_translate_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        file_path_data = json.load(f)
    with open(file_translate_path, 'r', encoding='utf-8') as f:
        file_translate_path_data = json.load(f)
    return file_path_data, file_translate_path_data


# python3 find_chinese_cstrings.py HDFindStringDemo
if __name__ == '__main__':
    print("start")
    macho_file = sys.argv[1]
    cstring_file = f"{macho_file}_cstring.txt"
    output_file = f"{macho_file}_cstring_output.json"
    file_translate_path = f"{macho_file}_cstring_output_translate.json"
    file_final_path = f"{macho_file}_cstring_output_final.json"

    ##########  翻译+读写全流程 ##########
    #  翻译+读写全流程 1. 使用otool命令，将二进制文件中的__cstring段落，导出到文件中
    otool_to_file(macho_file, cstring_file)

    # #  翻译+读写全流程 2. 从文件中读取数据，转成中文后，再进行翻译
    all_strings, all_translate_strings = translate_cstring(cstring_file)

    # # 翻译+读写全流程 3. 将翻译好的数据，写入到文件中
    write_ustring_local_file(
        output_file, file_translate_path, all_strings, all_translate_strings)

    # # 翻译+读写全流程 4. 将all_strings、all_translate_strings 以 "中文"="English" 的形式写入file_final_path.json文件
    write_final_ustring_local_file(
        file_final_path, all_strings, all_translate_strings)
    ##########  翻译+读写全流程 ##########

    ##########  本地文件读取翻译 ##########
    # 本地文件读取翻译 1. 读取file_path、file_translate_path文件
    # all_strings, all_translate_strings = read_ustring_local_file(
        # output_file, file_translate_path)

    # 本地文件读取 2. 将all_strings、all_translate_strings 以 "中文"="English" 的形式写入file_final_path.json文件
    # write_final_ustring_local_file(
        # file_final_path, all_strings, all_translate_strings)
    ##########  本地文件读取翻译 ##########

    print("end")
