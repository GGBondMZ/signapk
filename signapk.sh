#!/bin/bash

# 设置默认值
cert_file="./platform.x509.pem"
key_file="./platform.pk8"
input_apk=""
output_apk=""
project_dir="."

# 定义帮助函数
usage() {
    cat <<EOF
Usage: $(basename "$0") [options] [APK_FILE]

Options:
    -c, --certificate <file>  Path to the certificate file (default: $cert_file)
    -k, --key <file>        Path to the key file (default: $key_file)
    -o, --output <file>     Path to the output .apk file (default: <input>_signed.apk)
    -p, --project <name>    Project name to find the certificate and key files (default: current directory)
    --help|-h               Show this help message and exit

Examples:
    ./$(basename "$0") --project A34_54 Demo.apk
    ./$(basename "$0") Demo.apk --output mysigned_Demo.apk
    ./$(basename "$0")

EOF
}

# 解析命令行参数
while getopts "c:k:o:p:h" opt; do
    case "$opt" in
        c) cert_file="$OPTARG" ;;
        k) key_file="$OPTARG" ;;
        o) output_apk="$OPTARG" ;;
        p)
            project_dir="$OPTARG"
            cert_file="$project_dir/platform.x509.pem"
            key_file="$project_dir/platform.pk8"
            ;;
        h) usage; exit 0 ;;
        \?) echo "Invalid option: -$OPTARG" >&2; usage; exit 1 ;;
    esac
done

shift $((OPTIND - 1))

# 获取APK文件名
if [ $# -gt 0 ]; then
    input_apk="$1"
    shift
fi

# 如果没有指定输出的 APK，则根据输入 APK 自动设置输出文件名
if [ -z "$output_apk" ] && [ ! -z "$input_apk" ]; then
    output_apk_base=$(basename "$input_apk")
    output_apk="${output_apk_base/_signed.apk/}.apk"
    output_apk="${output_apk_base/.apk/_signed.apk}"
fi

# 签名 APK 文件
sign_apk() {
    local input="$1"
    local output="$2"
    local result
    result=$(java -Djava.library.path=./tool/lib64 -jar ./tool/signapk.jar "$cert_file" "$key_file" "$input" "$output")

    if [ $? -ne 0 ]; then
        echo "Error: Failed to sign $input"
        echo "$result"
        exit 1
    fi
    echo "Signed $input to $output"
}

# 如果没有指定输入的 APK，则签名当前目录下所有的 .apk 文件
if [ -z "$input_apk" ]; then
    for file in *.apk; do
        if [ -f "$file" ]; then
            output_apk="${file/.apk/_signed.apk}"
            sign_apk "$file" "$output_apk"
        fi
    done
else
    if [ -f "$input_apk" ]; then
        sign_apk "$input_apk" "$output_apk"
    else
        echo "Error: Input file '$input_apk' does not exist."
        exit 1
    fi
fi
