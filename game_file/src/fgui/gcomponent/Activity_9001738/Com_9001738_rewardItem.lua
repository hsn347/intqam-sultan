local baseComponent = require("fgui.base.baseComponent")
local Com_9001738_rewardItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001738/Com_9001738_rewardItem", Com_9001738_rewardItem)
function Com_9001738_rewardItem:onInit()
	self.fields.Ani_item:setAllFrameName("dh_chuanqijunwang_%02d.png", 1)
	self.fields.Ani_item:setBlendFunc(gl.ONE, gl.ONE)
end
function Com_9001738_rewardItem:onShow()
end
local getInnerItem = function(btnItem)
	return btnItem.fields.item
end
local resetInnerItemCustomData = function(btnItem)
	local item = getInnerItem(btnItem)
	item:setCustomName(nil)
	item:setCustomTip(nil)
	item:openLongPress()
end
local initCustomRewardData = function(btnItem, data)
	local item = getInnerItem(btnItem)
	btnItem.id = 0
	if btnItem.fields.title then
		btnItem.fields.title:setString("")
	end
	item.id = 0
	item.num = 0
	item.idType = -1
	item.itemType = nil
	item:setupItemUI()
	item.controllers.c1:setSelectedIndex(0)
	item.controllers.c2:setSelectedIndex(0)
	item:hideEffect()
	item.fields.Lab_num:setVisible(false)
	item.fields.Lab_num:setString("")
	item.fields.Text_lv:setString("")
	item.fields.bg:setSpriteFrame("frame_item_base_01.png")
	item:setIcon(data.icon or "", nil, false)
	item:setCustomName(data.customName or "BUFF")
	item:setCustomTip(data.customTip or "")
	item:openLongPress()
end
function Com_9001738_rewardItem:initData(id, num)
	if type(id) == "table" then
		local data = id
		if data.isCustomReward == true then
			self.itemID = 0
			self.itemNum = 0
			initCustomRewardData(self.fields.Com_item, data)
			return
		end
		num = data.count
		id = data.id
	end
	self.itemID = id
	self.itemNum = num
	self.fields.Com_item:initData(id, num)
	resetInnerItemCustomData(self.fields.Com_item)
end
function Com_9001738_rewardItem:setStatus(status)
	self.controllers.c1:setSelectedIndex(status or 3)
end
return Com_9001738_rewardItem
