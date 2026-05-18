# GHomeBlazor

GHomePub のサブサイト。
表示先は [GHomeBlazor](https://gplayer2022.github.io/GHomeBlazor/) 。


## コンポーネントの雛形

```razor
@page "/"

@inject NavigationManager Nav

@code {
}
```

## VSCode 設定

`.razor` ファイルで emmet を有効化するための手順。

1. [設定?] > [設定] を押下
2. [設定の検索] 欄に `files:associations` と入力
3. ボタン [項目の追加] を押下し、 [項目] と [値] にそれぞれ下記のように入力する
  - [項目] : `*.razor`
  - [値] : `html`


## プロジェクト作成手順

1. メニュー [ファイル] > [新規作成] > [プロジェクト] を選択
1. ウィンドウ [新しいプロジェクトの作成] で `Blazor WebAssembly スタンドアロン アプリ` を選択し、ボタン [次へ] を押下
1. ウィンドウ [新しいプロジェクトを構成します] でプロジェクト名・場所・ソリューション名を設定し、ボタン [次へ] を押下
1. ウィンドウ [追加情報] で、下記のように設定し、ボタン [作成] を押下
    - フレームワーク: `.NET 8.0`
    - 認証の種類: `なし`
    - HTTPS 用の構成: ☑
    - プログレッシブ Web アプリケーション: □
    - サンプルページを含める: □
    - 最上位レベルのステートメントを使用しない: ☑
    - .NET Aspire オーケストレーションへの傘下: □

表示先は [ExBlazorWebAssembly](https://gplayer2022.github.io/ExBlazorWebAssembly/) 。


## 設定手順

1. `.github/workflows/gh-pages.yml` を設定する
    - 必ずソリューションのルートからの相対パスで指定すること！
    - 1 字たりとても間違えないこと！
1. GitHub リポジトリで `Settings` > `Pages` > `Branch` を `gh-pages` に設定する
1. GitHub リポジトリで `Settings` > `Actions` > `General` > `Workflow permissions` を `Read and write permissions` に設定する
1. Visual Studio でソリューションをコミットおよびプッシュする
1. ~~`publish.cmd` を実行する~~



## `.razor` ファイルの説明

ファイル名がそのままクラス名になるため、
クラス名を `Weather` にするためにファイル名を `Weather.razor` にする必要がある。
親クラスは `ComponentBase` が自動的に継承される。

```C#
public partial class Weather : ComponentBase
{
}
```

最初から用意されているメソッド群。

- OnInitialized / OnInitializedAsync
- OnParametersSet / OnParametersSetAsync
- OnAfterRender / OnAfterRenderAsync
- ShouldRender
- SetParametersAsync

`override` 修飾必須。

```razor
protected override async Task OnInitializedAsync()
{
    forecasts = await Http.GetFromJsonAsync<WeatherForecast[]>("sample-data/weather.json");
}
```


## Layout の仕組み

ファイル `App.razor` でデフォルトのレイアウトを指定する。

```razor
<Router AppAssembly="@typeof(App).Assembly">
    <Found Context="routeData">
        <RouteView RouteData="@routeData" DefaultLayout="@typeof(MainLayout)" />
        <FocusOnNavigate RouteData="@routeData" Selector="h1" />
    </Found>
    <NotFound>
        <PageTitle>Not found</PageTitle>
        <LayoutView Layout="@typeof(MainLayout)">
            <p role="alert">Sorry, there's nothing at this address.</p>
        </LayoutView>
    </NotFound>
</Router>
```

レイアウトをデフォルト以外にしたい場合は、各ページファイル側で下記のように指定する。

```razor
@layout AdminLayout
```



## YAML ファイルの説明

```yml
name: Deploy Blazor WASM to GitHub Pages

on:
  push:
    branches: [ "master" ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4

    - name: Setup .NET
      uses: actions/setup-dotnet@v4
      with:
        dotnet-version: 8.0.x

    - name: Publish
      run: dotnet publish -c Release -o release

    - name: Fix base href
      run: |
        sed -i 's|<base href="/" />|<base href="/ExBlazorWebAssembly/" />|g' release/wwwroot/index.html
        cp release/wwwroot/index.html release/wwwroot/404.html
        touch release/wwwroot/.nojekyll

    - name: Deploy
      uses: peaceiris/actions-gh-pages@v4
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: release/wwwroot
```






