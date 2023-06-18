class ArticlesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    article = Article.new(article_params)
    article.slug = to_slug(article.title)

    if article.save
      render json: { article: article }, status: :created
    else
      render json: { errors: article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    article = Article.find_by(slug: params[:slug])
    if article
      render json: { article: article }
    else
      render json: { error: "Article not found" }, status: :not_found
    end
  end

  def update
    article = Article.find_by(slug: params[:slug])
    if article
      article.slug = to_slug(article_params[:title]) if article_params[:title]
      if article.update(article_params)
        render json: { article: article }
      else
        render json: { errors: article.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Article not found" }, status: :not_found
    end
  end

    def destroy
    article = Article.find_by(slug: params[:slug])
    if article
      article.destroy
      render json: { message: "deleted" }
    else
      render json: { error: "Article not found" }, status: :not_found
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :description, :body)
  end

  def to_slug(title)
    title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end
end
