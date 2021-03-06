class Sender::AnimalsController < BaseController
  layout "sender"

  def index
    @animals = current_user.animals.with_attached_images.page(params[:page]).per(8)
  end

  def new
    @animal = current_user.animals.new
  end

  def create
    @animal = current_user.animals.build(animal_params)

    if @animal.save
      redirect_to sender_animals_path
    else
      render :new
    end
  end

  def edit
    @animal = Animal.find(params[:id])
  end

  def update
    @animal = Animal.find(params[:id])
    if @animal.update(animal_params)
      redirect_to sender_animals_path
    else
    end
  end

  def destroy
    @animal = Animal.find(params[:id])
    @animal.destroy
    redirect_to sender_animals_path
  end

  def destroy_image
    @animal = Animal.find(params[:id])
    @animal.images.find(params[:image_id]).purge
    render :edit
  end

  private

  def animal_params
    if current_user.latitude.present? && current_user.longitude.present?
      params.require(:animal).permit(:name,
                                     :animal_kind,
                                     :animal_sex,
                                     :animal_age,
                                     :animal_bodytype,
                                     :animal_colour,
                                     :animal_sterilization,
                                     :adopt_status,
                                     :content,
                                     images: [])
        .merge(animal_area_pkid: current_user.sender_add.slice(0..2), latitude: current_user.latitude, longitude: current_user.longitude)
    else
      params.require(:animal).permit(:name,
                                     :animal_kind,
                                     :animal_sex,
                                     :animal_age,
                                     :animal_bodytype,
                                     :animal_colour,
                                     :animal_sterilization,
                                     :adopt_status,
                                     :content,
                                     images: [])
        .merge(animal_area_pkid: current_user.sender_add.slice(0..2))
    end
  end
end
