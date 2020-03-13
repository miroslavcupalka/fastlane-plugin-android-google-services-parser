module Fastlane
  module Actions
    module SharedValues
      GOOGLE_SERVICES_APP_ID = :GOOGLE_SERVICES_APP_ID
    end

    class GetGoogleServicesJsonAppIdAction < Action
      
      def self.run(params)
        google_services_file_path = Helper::AndroidGoogleServicesParserHelper.get_google_services_file_path(params[:google_services_file])

        if !google_services_file_path
          UI.user_error!("Unable to find the google.services.json file at #{google_services_file_path}.")
        end

        data = Helper::AndroidGoogleServicesParserHelper.get_google_services_app_id(google_services_file_path, params[:package_name])

        if !data
          UI.user_error!("Unable to find the APP ID in file at #{google_services_file_path}.")
          return
        end

        if (params[:package_name].nil? || params[:package_name].empty?) 
          UI.success("👍 Current app id is: #{data}")
        else
          UI.success("👍 Current app id for package #{params[:package_name]} is: #{data}")
        end

        # Store the google services app id in the shared hash
        Actions.lane_context[SharedValues::GOOGLE_SERVICES_APP_ID] = data
        return data
      end

      def self.description
        "Get the App Id from google-services.json"
      end

      def self.details
        "This action will return App Id from google-services.json file of your Android project."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :google_services_file,
                                  env_name: "FL_ANDROID_GOOGLE_SERVICES_PARSER_JSON_FILE",
                               description: "Specify the path to your app google-services.json if it isn't in the default location",
                                  optional: false,
                                      type: String,
                             default_value: "../google-services.json",
                              verify_block: proc do |value|
                                UI.user_error!("Could not find google-services.json file") unless File.exist?(value) || Helper.test?
                              end),
                              
                              
            FastlaneCore::ConfigItem.new(key: :package_name,
                              env_name: "FL_ANDROID_GOOGLE_SERVICES_PARSER_PACKAGE_NAME",
                           description: "(optional) Specify package name for app id if it isn't you get first App id",
                              optional: true,
                                  type: String)
                    
        ]
      end

      def self.output
        [
          ['GOOGLE_SERVICES_APP_ID', 'The App id of your google-services.json']
        ]
      end

      def self.return_value
        "The App id of google-services.json"
      end

      def self.authors
        ["Miroslav Čupalka"]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end

      def self.example_code
        [
          'firebase_app_id = get_google_services_json_app_id(google_services_file: File.absolute_path("../app/src/main/google-services.json"), package_name: "com.example.android")',
          'firebase_app_id = get_google_services_json_app_id(google_services_file: File.absolute_path("../app/src/main/google-services.json") # get first app id from google-services.json'
        ]
      end
    end
  end
end
