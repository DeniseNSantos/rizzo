class ComponentsController < ActionController::Base
  respond_to :html, :js, :mustache, :json
  helper_method :mustache_hash
  JSON = ActiveSupport::JSON

  def mustache_hash
    Hash.new do |hash, key|
      "{{#{key}}}"
    end
  end

  def view_args(format_symbol)
    case format_symbol
    when :mustache
      properties = mustache_hash
      return properties, :html
    when :html
      properties = params[:properties] ? JSON.decode(params[:properties]) : {}
      return properties.with_indifferent_access, :html
    end
  end

  def show
    @properties, response_format = view_args(request && request.format && request.format.symbol)

    begin
      if @properties and response_format
        render partial: "components/#{params[:component]}", locals: { properties: @properties }, formats: response_format
      else
        redirect_to "/404", status: 402
      end
    rescue
      # TEMPORARY: to force the error message
      render partial: "components/#{params[:component]}", locals: { properties: @properties }, formats: :html
    end
  end

end
