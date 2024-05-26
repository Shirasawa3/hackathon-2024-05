# frozen_string_literal: true

class Corp::Users::UploadsController < Corp::CorporateControllerBase
  def new; end

  def create
    params = upload_params
    file = params[:csv]
    overwrite = params[:overwrite] == '1'

    unless file.content_type.include?('text/csv')
      flash[:danger] = I18n.t('flash.corp.users_uploads.invalid_mime')
      redirect_to new_corp_users_upload_path
      return
    end

    begin
      upload_result = Corp::UploadUsersCsvUseCase.new.execute(file.open, overwrite)
    rescue => e
      flash[:danger] = e.message
      redirect_to new_corp_users_upload_path
      return
    end

    message = I18n.t('flash.corp.users_uploads.success', success_count: upload_result.success_count)
    if upload_result.skip_count > 0
      message += I18n.t('flash.corp.users_uploads.skip', skip_count: upload_result.skip_count)
    end
    flash[:success] = message
    redirect_to new_corp_users_upload_path
  end

  private

  def upload_params
    params.require(:upload).permit(:csv, :overwrite)
  end
end
