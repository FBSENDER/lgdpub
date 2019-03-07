require 'doc'

class ZiliaoController < ApplicationController
  def home
    render :home, layout: 'ziliao'
  end

  def download
    @doc = Doc.where(id: params[:id].to_i).take
    not_found if @doc.nil?
  end
end
