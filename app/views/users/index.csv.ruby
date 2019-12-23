require 'csv' # ← application.rbにも追加

CSV.generate(encoding: "CP932") do |csv|
    # ↑()の中のコードはexcelで開いたときに文字化けしないようにShift_JiSで開くよう指定
    #これを書かないとlinuxのデフォルトのUTF-8で開こうとして文字化けが起こる
    column_names =%w(ID 氏名 メールアドレス 作成日時)
    #↑配列に格納  
    csv << column_names
    @users.each do |user|
        #controller#indexで取得したユーザーデータを表示
        column_values = [
            user.id,
            user.name,
            user.email,
            user.created_at,
        ]
        csv << column_values
    end
end
