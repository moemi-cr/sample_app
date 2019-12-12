class User < ApplicationRecord
  attr_accessor :remember_token #インスタンス変数を直接変更して操作ができるようにする

  before_save { self.email = email.downcase } #メールアドレスを保存する前に小文字にする selfは現在のユーザーを指す
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i #メールアドレスの正規表現
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password 
  #セキュアにハッシュ化したパスワードを、db内のpassword_digest属性に保存できるようになる
  #2つのペアの仮想的な属性（passwordとpassword_confirmation）が使えるようになる。
  #また、存在性と値が一致するかどうかのバリデーションも追加される
  #authenticateメソッドが使えるようになる（引数の文字列がパスワードと一致するとUserオブジェクトを、間違っているとfalseを返すメソッド）。
  #※モデル内にpassword_digest属性が含まれていないと使えない
  validates :password, presence: true, length: { minimum: 6 }, allow_nil:true #ユーザー編集時に、allo_nil:true でパスワードを打たなくても変更できるようにする

  
  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    #remember_tokenのセッターメソッド呼び出し ※セッターはローカル変数と間違えてしまうためselfをつけないといけない
    self.remember_token = new_token
    #モデル内のremember_digest属性(カラム)の値を上書き
    update_attribute(:remember_digest, digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    #ローカル変数remember_tokenを定義 ※attr_accessorで定義したアクセサとは異なる
    return false if remember_digest.nil?
    #記憶ダイジェストがnilの場合にはreturnを使って即座にメソッドを終了
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    ##モデル内のremember_digest属性(カラム)の値をnilにする
    update_attribute(:remember_digest, nil)
  end
end