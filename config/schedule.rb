# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# ログを吐くファイルを指定
set :output, 'log/cron.log'
# 環境変数のパスを通す
env :PATH, ENV['PATH']
# デフォルトがproductionなのでdevelopmentに切り替える
set :environment, :development


every 1.minutes do
    rake 'export_csv:csv_export'
end

every 3.minutes do
    rake 'sample:sample'
end