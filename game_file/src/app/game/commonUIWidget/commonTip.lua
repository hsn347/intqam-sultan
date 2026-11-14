local publicRead = include("publicRead")
local commonTip = class("commonTip", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonTip")
	end
	return target
end)
function commonTip:ctor()
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
end
function commonTip:initData(id)
	if self.Text_name then
		self.Text_name:setString(publicRead.getName(id))
	end
	if self.Text_des then
		self.Text_des:setString(publicRead.getDes(id))
	end
end
return commonTip
