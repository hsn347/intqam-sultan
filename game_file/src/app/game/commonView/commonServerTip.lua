local commonServerTip = class("commonServerTip", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateTouchPanel("commonServerTip")
		end
		if type(target) == "string" then
			return SoraDCreateTouchPanel(target)
		end
		return target
	end
end)
function commonServerTip:ctor()
	self:createUI()
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.img_center_bg = SoraDGetChildByName(self, "img_center_bg")
	self.frame_bg = SoraDGetChildByName(self, "frame_bg")
	self.img_title_bg = SoraDGetChildByName(self, "img_title_bg")
	self.Text_title = SoraDGetChildByName(self, "Text_title")
	self.img_title_line = SoraDGetChildByName(self, "img_title_line")
	self.Text_Content = SoraDGetChildByName(self, "Text_Content")
end
function commonServerTip:createUI()
end
function commonServerTip:init(data)
	local title = data.title or ""
	local content = data.content or ""
	self.Text_title:setString(title)
	self.Text_Content:setString(content)
end
function commonServerTip:onMessageListener()
end
return commonServerTip
