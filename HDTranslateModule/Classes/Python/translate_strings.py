import xml.etree.ElementTree as ET
import subprocess

# xml 转成 原始的 .strings 文件
def convert_plist_to_strings(plist_path, strings_path):
    # 解析XML文件
    tree = ET.parse(plist_path)
    root = tree.getroot()

    # 打开一个新的.strings文件用于写入
    with open(strings_path, 'w', encoding='utf-8') as strings_file:
        # plist文件的结构通常包含一个顶层的<dict>元素
        dict_elements = root.findall('dict')
        for dict_element in dict_elements:
            # 遍历dict内的元素
            elements = list(dict_element)
            for i, element in enumerate(elements):
                if element.tag == 'key':
                    key_text = element.text
                    # 获取与key相邻的下一个string元素
                    if i+1 < len(elements) and elements[i+1].tag == 'string':
                        value_text = elements[i+1].text
                        # 写入转换后的键值对到.strings文件
                        strings_file.write(f'"{key_text}" = "{value_text}";\n')

def covert_strings_to_plist(strings_path, plist_path):
    # 使用 f-string 格式化命令
    command = f"plutil -convert xml1 {strings_path} -o {plist_path}"

    # 执行命令
    subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

# 调用函数进行转换
covert_strings_to_plist('mm.strings', 'mm.xml')
convert_plist_to_strings('mm.xml', 'mmOrigin.strings')

print('转换完成。')
