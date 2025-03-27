# 使用说明

## 查看帮助

```shell
./signapk.sh -h
```

输入结果:

```shell
Usage: signapk.sh [options]

Options:
  -c, --certificate <file>  Path to the certificate file (default: ./platform.x509.pem)
  -k, --key <file>          Path to the key file (default: ./platform.pk8)
  -i, --input <file>        Path to the input .apk file (sign all .apk files in current directory if not specified)
  -o, --output <file>       Path to the output .apk file (default: signed_<input>.apk)
  -p, --project <name>      Project name to find the certificate and key files (default: current directory)
  --help|-h                 Show this help message and exit

Examples:
  ./signapk.sh --project A34_54 --input Demo.apk
  ./signapk.sh --input Demo.apk --output mysigned_Demo.apk
  ./signapk.sh
```

| 参数 | 描述                                                    | 必选 |
|----|-------------------------------------------------------|----|
| -c | `--certificate`, `platform.x509.pem` 路径, 默认为当前目录下的    | 否  |
| -k | `--key`, 默认 `true`, `platform.pk8` 路径, 默认为当前目录下的      | 否  |
| -i | `--input`, 要签名的`APK`, 默认为当前目录下的所有`APK`                | 否  |
| -o | `--output`, 签名后的`APK`, 默认为当前目录, 要和`-i`同时用             | 否  |
| -p | `--project`, 用于指定`platfrom`签名路径, 用这个参数就不需要用`-c`和`-k`了 | 否  |
| -h | `--help`, 查看帮助                                        | 否  |