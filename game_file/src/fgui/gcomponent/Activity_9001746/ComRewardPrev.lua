local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local ComRewardPrev = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001746/ComRewardPrev", ComRewardPrev)
function ComRewardPrev:onInit()
	self.fields.listReward:setVirtual()
	self.fields.listReward:setItemRenderer(handler(self, self.itemRenderer_listReward))
	self.listRewardData, _ENV = self.fields.listReward.setItemRenderer, self.fields.listReward.setItemRenderer
	self.fields.txtName:fixPos()
	self.fields.icon:fixPos()
	self.fields.listReward:fixPos()
	self.fields.listReward:fixChildrenPos()
	self.fields.n12:fixPos()
	self.fields.n12:fix()
end
function ComRewardPrev:onShow()
end
function ComRewardPrev:initData(data)
	if not data then
		data, _UPVALUE0_ = nil, nil
	end
	if not data.rewards then
		_UPVALUE0_ = data.rewards
	end
	self.listRewardData = data.rewards
	self.fields.txtName:setString(data.title or "")
	self.fields.icon:setURL(data.iconUrl)
	self.fields.listReward:setNumItems(#self.listRewardData)
end
function ComRewardPrev:itemRenderer_listReward(index, obj)
	local data = self.listRewardData[index + 1]
	obj:initData(data.id, data.count)
end
return ComRewardPrev
