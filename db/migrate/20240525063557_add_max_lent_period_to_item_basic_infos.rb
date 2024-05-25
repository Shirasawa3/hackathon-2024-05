class AddMaxLentPeriodToItemBasicInfos < ActiveRecord::Migration[7.0]
  def change
    add_column :item_basic_infos, :max_lent_period, :interval
  end
end
