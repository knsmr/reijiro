# Reijiro

「Reijiro」は英辞郎CD-ROMを使った単語帳アプリです。単語ごとに学習時刻を記録し、その復習間隔を徐々に広げていくことで効率良く記憶定着を促す学習法「[Spaced Repetition](http://en.wikipedia.org/wiki/Spaced_repetition)」を実現しています。

![Reijiro](http://dl.dropbox.com/u/296/reijiro/reijiro01.png "Reijiro")

※ Reijiroの利用には英辞郎CD-ROMが必要です。CD-ROMは、[アルクのページ](http://shop.alc.co.jp/cnt/eijiro/?rfcd=SA_s_eng_dic_top)や[アマゾンのページ](http://www.amazon.co.jp/dp/4757419856/)から購入できます。

※ 古いバージョンの英辞郎CD-ROMはPDIC形式というフォーマットを使っていますが、ReijiroはPDICには対応していません。

※ 単に英辞郎CD-ROMを引くのが目的であれば、[EijiroX](https://github.com/edvakf/EijiroX)というソフトウェアがあります。テキストをSQlite3形式に変換して、Chromeエクステンションで、単語のインクリメンタルサーチができるそうです。

## 英辞郎をSpaced Repetitionで「読む」

Reijiroでは、ある単語を調べたり、単語集から取り入れると、その単語は1日後、3日後、1週間後、2週間後……というタイミングで提示されます。Spaced Repetition(SR)については、「[復習のタイミングを変えるだけで記憶の定着度は4倍になる](http://readingmonkey.blog45.fc2.com/blog-entry-499.html)」というブログが参考になります。

以下、ざっくりとした概要図を示します。

![Interval](http://dl.dropbox.com/u/296/reijiro/interval_buttons.png "復習の時間間隔を開けていく")

![review](http://dl.dropbox.com/u/296/reijiro/review.png)

![chart](http://dl.dropbox.com/u/296/reijiro/chart.png)

SRの研究や利活用の歴史は古く、少なくとも50年程度の歴史はあるようです。すでに多くのメソッドがあり、ここ20年ほどはソフトウェアやサービスとしても提供されています。ソフトウェアでは[SuperMemo](http://www.supermemo.com/)や[Anki](http://ankisrs.net/)が有名で、SRを取り入れた外国語学習サービスとしては[iKnow](http://iknow.jp)があります。明示的にユーザーに進ちょく管理を委ねる方法ばかりでなく、隠れマルコフモデルを使って個々のアイテムの記憶定着度を推定するようなアプローチもあるようです。

これらの先行するソフトウェアやサービスとReijiroの違いは、英辞郎を使っている点にあります。英辞郎は一般的な意味でいう辞書ではありません。用例と例文が豊富に収録されています。語彙の学習や増強というのが多数の語が作るネットワークの習得に他ならないとすれば、用例や文例を大量に眺めるのが効果あるのではないかと思います。

## 動作環境

- Ruby 1.9.2+
- Ruby on Rails 3.2+
- SQlite3
- Canvasを使っているのでIEではたぶん統計グラフが出ません（というか、その他も含めてIEでは動作確認をしていません）
- 基本的にローカルマシンで動かすことを想定しています。Mac OS XとLinuxで動作を確認していますが、Windowsでは辞書のインポートスクリプトが動かないと思います。
- サーバにデプロイすれば、タブレットやスマフォからも利用できます。
- RubyやRailsに関する知識がないと、インストールや利用は難しいと思います。すいません。

## インストール

最初にCD-ROMの辞書をSQlite3形式に変換します。

まずレポジトリをコピーして、`config/initializers/reijiro.rb` にある config.dictionary_path を編集します。英辞郎CD-ROMから展開したEIJI-128.TXTや、REIJI-128.TXTなどの辞書テキストファイルへのパスを書き入れてください。英辞郎CD-ROMに含まれるテキストファイルは、CD-ROMに含まれるZIPファイルを書籍に印字されているパスワードで解凍することで得られます。EIJI-128.TXの128はバージョンでCD-ROMの購入時期によって異なります。

    $ git clone https://github.com/knsmr/reijiro
    $ cd reijiro
    $ bundle install
    $ vi config/initializers/reijiro.rb

    module Reijiro
      class Application < Rails::Application
        # Set the path to EIJI-128.txt, etc.
        config.dictionary_path = "/path/to/Eijiro6T"
      end
    end

続いて、データベースを作成します。

    $ rake db:migrate
    $ rake db:seed
    :
    : (takes a while to convert)
    :

「rake db:seed」で、英辞郎形式のテキストファイルから、必要なSQlite3のデータベースを生成します。この変換には、2.8GHzのCore 2 Duo＋SSDの環境で、10分以上かかります。

※ 英辞郎のテキストファイルからSQlite3へ変換するコードは、[EijiroX](https://github.com/edvakf/EijiroX)のmakedatabase.rbの実装を参考にさせていただきました。

起動には、

    $ rails s

とか

    $ rails s -d

などとしてください。

ブラウザでhttp://localhost:3000/にアクセスすれば、Reijiroの画面が開きます。

サーバにデプロイする場合は、`config/initializers/basic_authentication.rb` でBASIC認証の設定をしてください。誰でもアクセスできる状態でサーバに置いておくと、著作権（公衆送信権）の侵害になりますので十分に注意してください。

    $ cd config/initializers
    $ mv basic_authentication.sample basic_authentication.rb
    $ (edit) basic_authentication.rb

## 使い方

### 語彙のインポート方法は2つ

起動しただけでは何も単語の登録がありません。まず、新たに単語や熟語表現をインポートします。インポート方法には2種類あります。

1つは上部メニューの「Import(ALC)」から、12段階のレベル別に5個ずつ単語をインポートする方法です。各レベルには単語が1000個含まれるので、合計1万2000個あります（アポストロフィのついた単語が全部で3つ抜け落ちていますが気にしないで）。

![Reijiro](http://dl.dropbox.com/u/296/reijiro/alcimport.png "ALCの1万2000語の基礎語彙をレベル別にインポート")

英辞郎を提供しているアルクは、独自に基礎語彙を選定してレベル付けしています。この1万2000語を抑えるのが基本的な目標となるでしょう。どんな感じか紹介すると、例えばレベル1には、「about、above、across、act」など中学校レベルの単語が含まれます。レベル5には、「abandon、abolish、absurd、abundance」などが、レベル12には「abate、abdicate、abdominal、abhor」などが含まれます。

日々調べる単語については、検索ウィンドウに対象語を入れるとことで、その単語や表現をインポートできます。英辞郎には「wreck havoc」などという熟語も入っていますが、こうした表現は、ふつうにスペース区切りで検索できます。

辞書検索にReijiroを使うことで「調べっぱなしで、その後は忘れたまま」という状態にならなくなります。空き時間にスマフォで復習できるからです。その時にどの語を復習すべきかは、Reijiroが知っています。

英辞郎は変わった辞書で、1つの語彙に複数のエントリが対応します。というよりも、各エントリには1つ、もしくは複数からなる単語や表現、例文が含まれていて、フラットな構造となっています。例えば、attireという単語であれば、以下のとおり数十のエントリがヒットします。

~~~
■attire {名} : （豪華｛ごうか｝な）衣装｛いしょう｝
■attire {他動} : 〜に盛装｛せいそう｝させる、めかす
■attire : 【レベル】12、【発音】эta'iэ(r)、【分節】at・tire
■appropriate attire : 適切｛てきせつ｝な［場にあった］服装｛ふくそう｝■・When choosing a costume, refer to the school's guidelines for appropriate attire. 衣装を選ぶ際には、学校の適切な［場にあった］服装のための指針［規則］を参照しなさい。
■attire for someone's wedding day : （人）の結婚式｛けっこんしき｝の衣装｛いしょう｝
■attire in suit and tie : ネクタイとスーツに身を固める
■attire oneself : 身支度する
■casual attire : カジュアルな服装｛ふくそう｝
:
:
■dreadful attire : ひどい［目を覆いたくなるような］服装｛ふくそう｝
■formal black attire : 黒の正装｛せいそう｝
■formal regal attire : 〈英〉公式｛こうしき｝の礼服｛れいふく｝
:
:
■in proper attire : きちんとした服装［身なり］で
■in wedding attire : 婚礼｛こんれい｝の衣装｛いしょう｝をつけて、花嫁｛はなよめ｝［花婿｛はなむこ｝］姿で
■informal attire : インフォーマル・ウェア、略礼装｛りゃくれいそう｝
:
:
■mourning attire : 喪服｛もふく｝
■proper attire for businessman : ビジネスマンにふさわしい服装｛ふくそう｝
■protective attire : 防護服｛ぼうご ふく｝、けがをしないような服装｛ふくそう｝
■relaxed-attire day : 《ビジネス》カジュアルな服装｛ふくそう｝の日
■skimpy attire : 肌もあらわな服装｛ふくそう｝
:
:
■"In Japan, wearing a necktie is the proper attire for formal occasions. : 「日本では正式の時の服装はネクタイ着用です。
■"The necktie is only one part of a person's attire. : 「ネクタイはその人の服装の一部にすぎない。
■Actually, my attire doesn't change in summer and winter, either. : 実は私も、夏と冬で服装が変わりません。
:
:
~~~

Reijiroでは、これら全てをattireに紐づいたものとして、1つのエントリに突っ込みます。

ちなみにattireに含まれる「morning attire」を再度検索し、独立したエントリとしてインポートすることもできます。例えば、pressing concern（差し迫った問題）などは、concernという項目ではなく、独立した1つの表現として覚えるほうが良いかもしれません。

用例や例文を全て読むことに価値がある（ので読んで覚えたい）というのがReijiroを作った動機です。「attire=衣装」などと1対1に訳語を覚えることが語彙力増強になると思いません。その語は、どういう語法で使われるか、どういう形容詞や動詞、名詞と結びついて使われるのかといった、いわゆるコロケーション情報が脳内に蓄積されないことには語彙力がつかないと思うからです。もう1つ例を挙げましょう。「dismiss=解散する」という語があります。これは実際には訴えや懇願、案などを棄却するとか退けるという意味で「dismiss a plea」「dismiss a case against something」「dismiss rumors as nothing」（うわさを一蹴する）などと使います。こうした用例を眺めることが重要です。ついでに形容詞のdismissiveや名詞のdismissalも調べて用例を眺めることで初めて、dismissという語が作る語彙のネットワークが何となく見えてくるものだと思います。

類義語や反意語については、Thesaurus.comを検索した結果を引用して自動的に貼り付けます。

英辞郎は日々成長している辞書ですが、2012年現在で項目数182万、例文数が恐らく20万程度含まれます。これは語数ではなく項目数です。実はALC12000のうち、初級レベルのものほど対応項目が多くて、読むのが大変です。インポートも若干もたつきます。でも、初級レベルのものほど英辞郎を「読む」価値が高いのではないかと思います。

### 語彙の復習

インポートした語彙は、3つの状態に分類されています。

1. 学習中の語彙のうち、チェック後間もない語彙
2. 学習中の語彙のうち、復習すべき語彙
3. 学習が完了した語彙

Nextボタンを押すことで2の語彙(復習すべき語彙)を1つ表示できます。Nextボタンを押したとき、復習すべき語彙は1つも残っていないかもしれません。

単語が表示された状態で、「Check and proceed」をクリックすると、その語は学習したということでチェック済みとなり、次にチェックすべき日が来るまでは1の状態になります。画面は次に復習すべき2の語彙に遷移します。

「復習すべき」というのは、その語彙を最後にチェックして(表示して何らかのボタンを押す)からどのぐらい時間が経過しているかによって決まります。0秒、1日、3日、1週間、2週間、1カ月、2カ月、4カ月と伸びていき、合計8回チェックしたらその語彙について学習完了となります。最初から復習間隔を一気に「1カ月後」にしたり「完了」にしても構いません。逆に、3日目に全く思い出せなくて不安を感じるなら、再び1日後に提示するように1 Dayボタンを押しても構いません。

### 用例の編集

インポートした単語の実例、用例、文例は編集できます。

1. 余計だと思ったら文例を削ることができます。
2. 自分にとって重要だと思った用例については、Editボタンを押して編集画面に移り、行頭の「■」を「@■」として半角のアットマークを付加することでアンダーラインを付けることができます。アンダーラインを付けると、蛍光マーカーで線を引いたように、大きく、目立つ色で先頭に表示されるようになります。

![highlight](http://dl.dropbox.com/u/296/reijiro/highlight.png "行頭に@を付ければマーカーを引いたように目立つ表示に")

すでに知っている単語、例えば「crash」という語でも、米口語の「寝る」という用法だけを覚えたいというようなときには、この編集機能が便利です。

### 進捗状況の確認

インポートした単語の数は、以下のようにレベル別に棒グラフで見ることができます。

![stats](http://dl.dropbox.com/u/296/reijiro/stats.png "進捗状況の確認")

## ライセンス

MIT Licence
