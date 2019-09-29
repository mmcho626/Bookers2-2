class Book < ApplicationRecord



 belongs_to :user

 has_many :book_comments, dependent: :destroy


 validates :title,:body, presence: true

 validates :body, length: { maximum: 199 }



# 追加


 # def user
 #    return User.find_by(id: self.user_id)
 #  end


end
