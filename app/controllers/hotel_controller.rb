class HotelController < ApplicationController
  def home
    @title = '民宿住宿_短租日租_酒店宾馆_度假公寓_家庭旅馆-滴滴住宿'
    @page_keywords = '民宿预订,住宿预订,滴滴住宿,家庭旅馆,台湾民宿,日本民宿,韩国民宿,泰国民宿,短租公寓,旅馆预订,宾馆预订,酒店预订'
    @description = '滴滴住宿全球公寓民宿预订平台！提供国内外特色住宿，酒店式公寓、短租日租公寓、家庭旅馆、特色民宿在线预订。民宿价格查询，酒店地址电话查询及在线预订。'
    @path = '/'
    @related_hotels =Hotel.order(:id).limit(50).select(:url_path_md5, :hotel_name)
    @countries = Hotel.select(:country_short, :country_name).distinct
    render "hotel/home", layout: "layouts/amp_hotel"
  end

  def show
    @hotel = Hotel.where(url_path_md5: params[:md5]).take
    if @hotel.nil?
      not_found
    end
    @related_hotels = Hotel.where(city_short: @hotel.city_short, hotel_type: @hotel.hotel_type).where("id > ?", @hotel.id).order(:id).limit(10).select(:url_path_md5, :hotel_name).to_a
    @related_hotels = Hotel.where(country_short: @hotel.country_short, hotel_type: @hotel.hotel_type).where("id > ?", @hotel.id).order(:id).limit(10).select(:url_path_md5, :hotel_name) if @related_hotels.size.zero?
    @rand_hotels = Hotel.where("id > ?", rand(123930)).limit(10).select(:url_path_md5, :hotel_name, :address, :images)
    @title = @hotel.hotel_name + "图片信息-特色简介-地图位置-酒店公寓预订"
    @page_keywords = "#{@hotel.hotel_name},#{@hotel.hotel_name}图片,#{@hotel.hotel_name}简介,#{@hotel.hotel_name}位置,#{@hotel.hotel_name}预订,#{@hotel.hotel_name}预定"
    @description = "滴滴住宿为您推荐位于#{@hotel.address}的酒店-#{@hotel.hotel_name}，可以查看其地图位置、图片、简介以及更多详细信息。"
    @path = "#{request.path}/"
    @h1 = @hotel.hotel_name
    @imgs = @hotel.images.split(',')
    @ld_json = {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": []
    }
    @ld_json[:itemListElement] << {
      "@type": "ListItem",
      "position": 1,
      "name": "滴滴住宿",
      "item": "http://mobile.ddzhusu.com"
    }
    @ld_json[:itemListElement] << {
      "@type": "ListItem",
      "position": 2,
      "name": "#{@hotel.country_name}",
      "item": "http://mobile.ddzhusu.com/hotel_country/#{@hotel.country_short}/"
    }
    position = 2
    if @hotel.region_short != ""
      position += 1
      @ld_json[:itemListElement] << {
        "@type": "ListItem",
        "position": position,
        "name": "#{@hotel.region_name}",
        "item": "http://mobile.ddzhusu.com/hotel_region/#{@hotel.region_short}/"
      }
    end
    if @hotel.city_short != ""
      position += 1
      @ld_json[:itemListElement] << {
        "@type": "ListItem",
        "position": position,
        "name": "#{@hotel.city_name}",
        "item": "http://mobile.ddzhusu.com/hotel_city/#{@hotel.city_short}/"
      }
    end
    position += 1
    @ld_json[:itemListElement] << {
      "@type": "ListItem",
      "position": position,
      "name": "#{@hotel.hotel_name}",
      "item": "http://mobile.ddzhusu.com/hotel/#{@hotel.url_path_md5}/"
    }
    render "hotel/show", layout: "layouts/amp_hotel"
  end

  def hotel_country
    @hotel = Hotel.where(country_short: params[:country_short]).take
    unless is_robot?
      redirect_to "http://www.booking.com/country/#{@hotel.country_short}.zh-cn.html?aid=895877"
      return
    end
    @title = "#{@hotel.country_name}酒店预订-滴滴住宿"
    @page_keywords = '民宿预订,住宿预订,滴滴住宿,家庭旅馆,台湾民宿,日本民宿,韩国民宿,泰国民宿,短租公寓,旅馆预订,宾馆预订,酒店预订'
    @description = "滴滴住宿全球公寓民宿预订平台！提供#{@hotel.country_name}特色住宿，酒店式公寓、短租日租公寓、家庭旅馆、特色民宿在线预订。民宿价格查询，酒店地址电话查询及在线预订。"
    @path = "/hotel_country/#{@hotel.country_short}/"
    @related_hotels = Hotel.where(country_short: @hotel.country_short).limit(50).select(:url_path_md5, :hotel_name, :address, :images)
    @regions = Hotel.where(country_short: @hotel.country_short).select(:region_short, :region_name).distinct
    if @regions.size.zero?
      @cities = Hotel.where(country_short: @hotel.country_short).select(:city_short, :city_name).distinct
    else
      @cities = []
    end
    @rand_hotels = Hotel.where("id > ?", rand(123930)).limit(10).select(:url_path_md5, :hotel_name, :address, :images)
    render "hotel/hotel_country", layout: "layouts/amp_hotel"
  end

  def hotel_region
    @hotel = Hotel.where(region_short: params[:region_short]).take
    unless is_robot?
      redirect_to "http://www.booking.com/region/#{@hotel.country_short}/#{@hotel.region_short}.zh-cn.html?aid=895877"
      return
    end
    @title = "#{@hotel.region_name}酒店预订-滴滴住宿"
    @page_keywords = '民宿预订,住宿预订,滴滴住宿,家庭旅馆,台湾民宿,日本民宿,韩国民宿,泰国民宿,短租公寓,旅馆预订,宾馆预订,酒店预订'
    @description = "滴滴住宿全球公寓民宿预订平台！提供#{@hotel.region_name}特色住宿，酒店式公寓、短租日租公寓、家庭旅馆、特色民宿在线预订。民宿价格查询，酒店地址电话查询及在线预订。"
    @path = "/hotel_region/#{@hotel.region_short}/"
    @related_hotels = Hotel.where(region_short: @hotel.region_short).limit(50).select(:url_path_md5, :hotel_name, :address, :images)
    @cities = Hotel.where(region_short: @hotel.region_short).select(:city_short, :city_name).distinct
    @rand_hotels = Hotel.where("id > ?", rand(123930)).limit(10).select(:url_path_md5, :hotel_name, :address, :images)
    render "hotel/hotel_region", layout: "layouts/amp_hotel"
  end

  def hotel_city
    @hotel = Hotel.where(city_short: params[:city_short]).take
    unless is_robot?
      redirect_to "http://www.booking.com/city/#{@hotel.country_short}/#{@hotel.city_short}.zh-cn.html?aid=895877"
      return
    end
    @title = "#{@hotel.city_name}酒店预订-滴滴住宿"
    @page_keywords = '民宿预订,住宿预订,滴滴住宿,家庭旅馆,台湾民宿,日本民宿,韩国民宿,泰国民宿,短租公寓,旅馆预订,宾馆预订,酒店预订'
    @description = "滴滴住宿全球公寓民宿预订平台！提供#{@hotel.city_name}特色住宿，酒店式公寓、短租日租公寓、家庭旅馆、特色民宿在线预订。民宿价格查询，酒店地址电话查询及在线预订。"
    @path = "/hotel_city/#{@hotel.city_short}/"
    @related_hotels = Hotel.where(city_short: @hotel.city_short).limit(50).select(:url_path_md5, :hotel_name, :address, :images)
    @rand_hotels = Hotel.where("id > ?", rand(123930)).limit(10).select(:url_path_md5, :hotel_name, :address, :images)
    render "hotel/hotel_city", layout: "layouts/amp_hotel"
  end

end
