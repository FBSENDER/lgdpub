class HotelController < ApplicationController
  def home
    @title = '民宿住宿_短租日租_酒店宾馆_度假公寓_家庭旅馆-滴滴住宿'
    @page_keywords = '民宿预订,住宿预订,滴滴住宿,家庭旅馆,台湾民宿,日本民宿,韩国民宿,泰国民宿,短租公寓,旅馆预订,宾馆预订,酒店预订'
    @description = '滴滴住宿全球公寓民宿预订平台！提供国内外特色住宿，酒店式公寓、短租日租公寓、家庭旅馆、特色民宿在线预订。民宿价格查询，酒店地址电话查询及在线预订。'
    @path = '/'
    @related_hotels =Hotel.order(:id).limit(50).select(:url_path_md5, :hotel_name)
    render "hotel/home", layout: "layouts/amp_hotel"
  end
  def show
    @hotel = Hotel.where(url_path_md5: params[:md5]).take
    if @hotel.nil?
      not_found
    end
    @related_hotels =Hotel.where("id > ?", @hotel.id).order(:id).limit(10).select(:url_path_md5, :hotel_name)
    @title = @hotel.hotel_name + "图片信息-特色简介-地图位置-酒店公寓预订"
    @page_keywords = "#{@hotel.hotel_name},#{@hotel.hotel_name}图片,#{@hotel.hotel_name}简介,#{@hotel.hotel_name}位置,#{@hotel.hotel_name}预订,#{@hotel.hotel_name}预定"
    @description = "滴滴住宿为您推荐位于#{@hotel.address}的酒店-#{@hotel.hotel_name}，可以查看其地图位置、图片、简介以及更多详细信息。"
    @path = "#{request.path}/"
    @h1 = @hotel.hotel_name
    @imgs = @hotel.images.split(',')
    render "hotel/show", layout: "layouts/amp_hotel"
  end
end
