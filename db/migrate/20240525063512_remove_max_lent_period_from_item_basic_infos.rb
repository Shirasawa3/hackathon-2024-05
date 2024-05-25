class RemoveMaxLentPeriodFromItemBasicInfos < ActiveRecord::Migration[7.0]
  def change
    remove_column :item_basic_infos, :max_lent_period
  end
end
