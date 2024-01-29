# DES-CBC方式の暗号化／復号化のお試し
## 元のエンコーディングが想定とは違う場合、間違った出力が期待できるのはわかる
## 実際にはどのような出力になるのか、事例を造りたかった。

## 使い方
- メイン処理にinputfileの引数として読み取りたいテキストデータを用意する
- メイン処理を実行
- ターミナルにエンコード処理のエラーの回数がでる
- 想定としては"2"が表示される

## 処理概要
- 元のファイルのエンコーディングとは関係なしにUTF8とSJISで読み込む
- サブバッチ内で指定したパラメータでDES-CBC方式に暗号化する
- それぞれ暗号化されるため2ファイルのbase64エンコードのファイルが作成される
- この2ファイルを復号化した後にUTF8とSJISに戻す

※バッチファイルはUTF8(BOM付)