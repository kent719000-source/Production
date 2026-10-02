<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%-- エラー画面（S-19）。header.jspf は loginUser を使うので、ログイン前のエラーでも落ちないよう <head> をここに書く --%>
            <!DOCTYPE html>
            <html lang="ja">

            <head>
                <meta charset="UTF-8">
                <title>エラー | ホゴタロウ</title>
            </head>

            <body>
                <%-- Spring Boot が status（HTTP の番号）をモデルに入れてくれる。Java のエラー処理クラスは書かない（基本設計 8 章） 400:
                    フォームの値の形がおかしい（日付の欄に文字、他団体の id を送られた など。普通に画面を使っていれば起きない） 403: 権限が無い（ボランティアが登録画面の URL を直接開いた など） 404:
                    無い id（他団体の id を含む）。Service の find() の orElseThrow が出す 413: 写真が 5MB を超えた（application.properties の
                    max-file-size） --%>
                    <h1>エラー ${status}</h1>
                    <c:choose>
                        <c:when test="${status == 400}">
                            <p>送信された内容に誤りがあります。画面を開き直してから、もう一度操作してください</p>
                        </c:when>
                        <c:when test="${status == 403}">
                            <p>この操作を行う権限がありません</p>
                        </c:when>
                        <c:when test="${status == 404}">
                            <p>指定されたデータは存在しません</p>
                        </c:when>
                        <c:when test="${status == 413}">
                            <p>ファイルは 5MB 以下にしてください</p>
                        </c:when>
                        <c:otherwise>
                            <p>システムエラーが発生しました。時間を置いて再度お試しください</p>
                        </c:otherwise>
                    </c:choose>
                    <p><a href="/">トップページへ</a></p>
            </body>

            </html>