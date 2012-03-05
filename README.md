# Reijiro

英辞郎を読んで英語の語彙や表現を覚えるためのたRailsアプリです。利用には英辞郎CD-ROMが必要です。CD-ROMは、[アルクのページ](http://shop.alc.co.jp/cnt/eijiro/?rfcd=SA_s_eng_dic_top)や[アマゾンのページ](http://www.amazon.co.jp/dp/4757419856/)から購入できます。

「[復習のタイミングを変えるだけで記憶の定着度は4倍になる](http://readingmonkey.blog45.fc2.com/blog-entry-499.html)」というブログにある、Spaced Repetitionという学習法が、半自動でできます。ある辞書の項目について、復習のタイミングを1日、3日、1週間、2週間……などと間遠にしていくことができます。

※ 単に英辞郎を引くのが目的であれば、[EijiroX](https://github.com/edvakf/EijiroX)という素晴らしいプロジェクトがあります。テキストをSQlite3形式に変換して、ブラウザのエクステンションでインクリメンタルサーチができるそうです。

## 動作環境

- Ruby 1.9系
- Ruby on Rails 3.2系
- SQlite3
- Canvasを使っているのでIEでは統計グラフが出ません（というか、その他も含めてIEでは動作確認をしていません）
- ローカルマシンで動かすことを想定しています。開発はMac上なので、Linuxでは動くと思いますが、Windowsではインポートスクリプトが動かないと思います。
- 英辞郎CD-ROMに含まれる内容をサーバにデプロイすることは、たとえユーザーが自分1人だけであっても著作権（公衆送信権）の侵害になり得ます。

## インストール

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

    $ rake db:migrate
    $ rake db:seed
    :
    : (takes a while to convert)
    :
    $ rails s

「rake db:seed」で、英辞郎形式のテキストファイルから、必要なSQlite3のデータベースを生成します。この変換には、2.8GHzのCore 2 Duo＋SSDの環境で、10分以上かかります。変換前に、設定ファイルのconfig/initializers/reijiro.rbを編集して、EIJI-128.TXTや、REIJI-128.TXTなど、英辞郎CD-ROMに含まれるテキストファイル群へのパスを指定してください。テキストファイルは、CD-ROMに含まれるZIPファイルを書籍に印字されているパスワードでzip解凍することで得られます。

※ 英辞郎のテキストファイルからSQlite3へ変換するコードは、[EijiroX](https://github.com/edvakf/EijiroX)のmakedatabase.rbの実装を参考にさせていただきました。

## 使い方

### 語彙のインポート方法は2つ

起動しただけでは何も単語の登録がありません。まず、新たに単語や表現をインポートします。インポート方法には2種類あります。1つは上部メニューの「Import(ALC)」から、12段階のレベル別に10個ずつ単語をインポートする方法です。各レベルには1000個含まれるので、合計1万2000個あります。英辞郎を提供しているアルクは、独自に基礎語彙を選定してレベル付けしています。この1万2000語を抑えるのが基本的な目標となるでしょう。

日々調べる単語については、検索ウィンドウに対象語を入れるとことでインポートできます。

ちなみに、英辞郎は変わった辞書で、1つの語彙に多数のエントリが対応します。というよりも、各エントリには1つ、もしくは複数からなる単語や表現、例文が含まれていて、フラットな構造となっています。例えば、attireという単語であれば、以下のとおり数十のエントリがヒットします。

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

Reijiroでは、これら全てをattireに紐づいたものとして、1つのエントリに突っ込みます（ちなみにattireに含まれる「morning attire」を再度検索し、独立したエントリとしてインポートすることもできます）。

用例や例文を全て読むことに価値がある（ので読んで覚えたい）というのがReijiroを作った動機です。「attire=衣装」などと1対1に訳語を覚えることが語彙力増強になると思いません。どういう語法で使われるか、どういう形容詞や動詞、名詞と結びついて使われるのかといった、いわゆるコロケーション情報が脳内に蓄積されないことには語彙力がつかないと思うからです。もう1つ例を挙げると、「dismiss=解散する」というのがあります。しかし、実際には訴えや懇願、案などを棄却する、退けるという意味で「dismiss a plea」「dismiss a case against」「dismiss rumors as nothing」（うわさを一蹴する）などと使います。用例重要。ついでに形容詞のdismissiveや名詞のdismissalも調べて用例を眺めることで初めて、dismissという語が作る語彙のネットワークが何となく見えてくるものだと思います。

英辞郎には項目数182万、例文数が恐らく20万程度含まれます。実はALC12000のうち、初級レベルのものほど対応項目が多くて、読むのが大変です。インポートも若干もたつきます。でも、初級レベルのものほど、実は英辞郎を読む価値が高いのではないかと思います。

### 語彙の復習

インポートした語彙は、3つの状態に分類されています。

1. 学習中の語彙のうち、チェック後間もない語彙
2. 学習中の語彙のうち、復習すべき語彙
3. 学習が完了した語彙

Nextボタンを押すことで2の語彙を1つ表示できます。1つもないかもしれません。

単語が表示された状態で、「Check and proceed」をクリックすると、その語はチェック済みとなり、次にチェックすべき日が来るまでは1の状態になります。画面は次の2の語彙に遷移します。

「復習すべき」というのは、その語彙を最後にチェックしてからどのぐらい時間が経過しているかによって決まります。0秒、1日、3日、1週間、2週間、1カ月、2カ月、4カ月と伸びていき、合計8回チェックしたらその語彙について学習完了となります。最初から復習間隔を一気に「1カ月後」にしたり「完了」にしても構いません。

復習すべき語彙数は、「NextUp」のところに表示しています。どのぐらいのペースで語彙を追加インポートすべきなのか、まだ作った本人も良く分かっていません。

## ライセンス

アプリケーションに含まれるフレームワークやライブラリは、それぞれのライセンスに準拠します。アプリケーション自体はMITライセンスとします。
