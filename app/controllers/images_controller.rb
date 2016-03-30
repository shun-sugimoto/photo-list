class ImagesController < ApplicationController
  include ImagesHelper
    before_action :logged_in_user
    
    def new
    end
    
    def create
        file = params[:file]
        if  (file != nil) &&  (file.content_type == "image/jpeg" || file.content_type =="image/jpg")
          
          
          exif = EXIFR::JPEG.new(file.tempfile)
          if is_exif?(exif)
            image_meta = image_meta(exif)
          else
            flash[:danger] = "必要なexif情報がありません。緯度経度、撮影日時を入力してください"
            redirect_to action: 'new' and return
          end
          uploadfile = upload_file(file)

          @image = Image.new
          @image.attributes ={  user_id:      current_user.id,
                                google_id:    uploadfile.id,
                                latitude:     image_meta[:latitude] ,
                                longitude:    image_meta[:longitude], 
                                address:      image_meta[:address], 
                                full_address: image_meta[:full_address]}
          
          if @image.save
            flash[:danger] = "画像を登録しました"
            redirect_to current_user
          else 
            @google_file= google_auth_session.file_by_id(@image[:id])
            flash[:danger] = "登録に失敗しました"
            redirect_to :action =>"new"
          end
        else
          flash[:danger] = 'アップロードする画像はjpegかjpeg形式でお願いします。'
          redirect_to :action =>"new"
        end
    end

    def show
      @show_file = Image.find_by(id: params[:id])
    end
    
    
    def get_image
      file = Image.find_by(id: params[:id])       
      if file.user_id != current_user.id
        redirect_to current_user
      end
      
      file = download_file(file)
      send_data file, type: "image/jpg", disposition: :inline  
    end
    
    def edit
      @edit_file = Image.find_by(id: params[:id])
    end
    
    def update
      @update_file = Image.find_by(id: params[:id])
      @image = params.require(:image).permit(:comment)
      if @update_file.update(@image)
      
        redirect_to @update_file
      else
        render 'edit'
      end
    end
      
  
    def destroy
      @delete_file = Image.find_by(id: params[:id])
      
      #Googleドライブから削除
      delete_file(@delete_file)
      
      flash[:success] = "Image Deleted" 
      redirect_to current_user
    end
end
