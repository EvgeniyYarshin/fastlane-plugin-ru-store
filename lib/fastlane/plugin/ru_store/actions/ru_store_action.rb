require 'fastlane/action'
require "fastlane_core/ui/ui"

module Fastlane
  module Actions
    class RuStorePublishAction < Action
      def self.authors
              ["eaiarsh1"]
      end

      def self.description
        "RuStore fastlane integration plugin"
      end

      def self.run(params)
        package_name = params[:package_name]
        company_id = params[:company_id]
        private_key = params[:private_key]
        publish_type = params[:publish_type]
        file_path = params[:file_path]

        # Получение токена
        token = Helper::RustoreHelper.get_token(company_id: company_id, private_key: private_key)
        # Создание черновика
        draft_id = Helper::RustoreHelper.create_draft(token, package_name, publish_type)
        # Загрузка aab
        Helper::RustoreHelper.upload_aab(token, draft_id, file_path, package_name)
        # Отправка на модерацию
        Helper::RustoreHelper.commit_version(token, draft_id, package_name)

      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :package_name,
                                       env_name: "RUSTORE_PACKAGE_NAME",
                                       description: "пакет приложения, например `com.example.example`",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :company_id,
                                       env_name: "RUSTORE_COMPANY_ID",
                                       description: "айдишник компании в русторе",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :private_key,
                                       env_name: "RUSTORE_PRIVATE_KEY",
                                       description: "приватный ключ в русторе",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :publish_type,
                                       env_name: "RUSTORE_PUBLISH_TYPE",
                                       description: "Тип публикации (MANUAL, DELAYED, INSTANTLY). По умолчанию - INSTANTLY",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :file_path,
                                       env_name: "RUSTORE_AAB",
                                       description: "путь до aab",
                                       optional: false),
        ]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end
