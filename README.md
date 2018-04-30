# TwitterKitLoginExample

TwitterKitをつかってのログイン検証用プロジェクト

## 🤔

`TWTRTwitter`をつかってログインしたときに１回めは普通にできるのだけれど、  
アプリを一度killしたりしてアプリ再起動すると、再度ログインしないといけない...。

公式リポのwikiとかみてもそこら辺の話はとくにないのだけれど...

`TWTRTwitter.sharedInstance().sessionStore.save(session:completion:)`というのもあるけど、  
ログイン成功時にそれを通しても結果は変わらずダメ...

### Carthage？

まさ！？とはおもって、Cocoapods経由でいれたら、コードは何も変えずとも期待しているとおり動いた...😇  
根本の原因はわからないけれど....Carthageでいれるのやらないほうがいいかもしれない

## 遊び方

cloneしてBuild Settingにある**TWITTER_CONSUMER_KEY**と**TWITTER_CONSUMER_SECRET**を設定したら実行できるはず。  
CarthageもCocoapodsも成果物もまるっとコミットしているので、インストールは不要...なはず