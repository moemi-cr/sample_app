namespace :export_csv do
    desc '使用者一覧をcsvで出力する'
    task csv_export: [:environment] do
        to_csv
    end

    def self.to_csv
        users = User.all
        file_name = "#{Settings.export_csv[:export_file_name]}.csv"
        file_path = Pathname.new(Settings.export_csv[:export_dir]).join(file_name)
        CSV.open(file_path, 'w', encoding: 'CP932') do |csv|
          column_names = %w(ID 氏名 メールアドレス)
          csv << column_names
          users.each do |user|
            column_values = [
              user.id,
              user.name,
              user.email
            ]
            csv << column_values
          end
        end
    end
end