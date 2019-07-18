class Admin::ComicsController < AdminController
  before_action :load_comic, only: :show

  def index
    @comics = Comic.name_alphabet.page(params[:page])
                   .per Settings.comic.per_page
  end

  def show
    @category = Category.find_by id: @comic.category_id
    @chapters = @comic.chapters.recent_upload.page(params[:page])
                      .per Settings.chapter.per_page
  end

  def new
    @comic = Comic.new
  end

  def create
    @comic = Comic.new comic_params

    if @comic.save
      flash[:success] = t ".success"
      redirect_to admin_comic_path(@comic)
    else
      render :new
    end
  end

  private

  def comic_params
    params.require(:comic).permit Comic::COMIC_ATTR
  end

  def load_comic
    @comic = Comic.find_by id: params[:id]
    return if @comic

    flash[:danger] = t "common.comic_not_found"
    redirect_to admin_root_path
  end
end
