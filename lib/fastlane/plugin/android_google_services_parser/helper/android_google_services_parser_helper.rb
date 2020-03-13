module Fastlane
    module Helper
      class AndroidGoogleServicesParserHelper
        require "shellwords"
        require "tempfile"
        require "fileutils"
        require "json"
  
        GOOGLE_SERVICES_FILE_TEST = "/tmp/fastlane/tests/androidgoogleservicesparser/google-services.json"
  
        def self.get_google_services_file(google_services_file)
          return Helper.test? ? GOOGLE_SERVICES_FILE_TEST : google_services_file
        end
  
        def self.get_google_services_file_path(google_services_file)
            google_services_file = self.get_google_services_file(google_services_file)
          return File.expand_path(google_services_file).shellescape
        end

        def self.get_google_services_app_id(google_services_file_path, package_name)

          json_file = File.open google_services_file_path

            data = JSON.load json_file

            data['client'].each { |n| 
            
              appId = n['client_info']["mobilesdk_app_id"]
              package = n['client_info']["android_client_info"]["package_name"]

          
              if (package_name.nil? || package_name.empty?) || package == package_name 
                # puts "equals: #{package}, #{appId}\n\n\n"
                return appId
              # else
                # puts "not equals: #{package}, #{appId}\n\n\n"
              end                      
          }
            
          return
        end
 
      end
    end
  end
  