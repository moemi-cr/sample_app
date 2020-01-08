require 'csv' 

class Users::UserExport
    def self.to_csv(users)
        CSV.generate(encoding: "CP932") do |csv|
        
            column_names =%w(ID 氏名 メールアドレス 作成日時)
            csv << column_names
            users.each do |user|
                column_values = [
                    user.id,
                    user.name,
                    user.email,
                    user.created_at,
                ]
                csv << column_values
            end
        end
    end
end

