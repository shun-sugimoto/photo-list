module ImagesHelper
    
    # Oauth認証する
    def google_auth_session
        client = Google::APIClient.new
        
        auth = client.authorization
        auth.client_id = ENV["CLIENT_ID"] # 「クライアントID」の文字列
        auth.client_secret = ENV["CLIENT_SECRET"] # 「クライアントシークレット」の文字列
        auth.refresh_token = ENV["REFRESH_TOKEN"]
        auth.fetch_access_token!

        @session = GoogleDrive.login_with_oauth(client)
    end
    
    # ファイル一覧を取得
    def file_list
        @list = google_auth_session.files
    end
    
    # 画像をアップロードする
    def upload_file(file)
        @file = google_auth_session.upload_from_file(file.tempfile, file.original_filename, convert: false)
    end
    
    # google_idから画像を特定する
    def find_file(file)
        @file = google_auth_session.file_by_id(file.google_id)
    end
    
    # google_idから画像を特定し、画像を削除する。
    def delete_file(file)
        file= find_file(file)
        file.delete(true)
    end
    
    # 画像をStringでダウンロードする
    def download_file(file)
        file = find_file(file)
        @file_string = file.download_to_string()
    end
    
    
    # 画像のメタ情報を取得
    def image_meta(file)
        # exifの取得
        exif = EXIFR::JPEG.new(file.tempfile)
         
        # 撮影日
        exif.date_time_original
         
        # 緯度
        latitude = (exif.gps_latitude[0].to_f + (exif.gps_latitude[1].to_f)/60 + (exif.gps_latitude[2].to_f)/3600).to_s
         
        # 軽度
        longitude = (exif.gps_longitude[0].to_f + (exif.gps_longitude[1].to_f)/60 + (exif.gps_longitude[2].to_f)/3600).to_s
         
        # 緯度軽度の結合
        location = [latitude,longitude].join(",")

        # 緯度経度から住所を取得
        Geocoder.configure(:language => :ja,:units => :km )
         
        response_geocoder = Geocoder.search(location)[0]
        full_address = response_geocoder.formatted_address
        
        address = response_geocoder.address_components
        if address[address.length - 1]['types'] = ["postalcode"]
            address.delete_at(-1)
        end
        address = address[address.length - 1 ]['long_name'] << 
                    address[address.length - 2 ]['long_name'] << 
                    address[address.length - 3 ]['long_name']
                    
        @image_meta = {
            :latitude     => latitude,
            :longitude    => longitude,
            :full_address => full_address,
            :address      => address
        }
    end
    
end
