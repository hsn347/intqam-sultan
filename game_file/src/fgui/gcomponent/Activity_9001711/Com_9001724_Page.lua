local baseComponent = require("fgui.base.baseComponent")
local Com_9001724_Page = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001711/Com_9001724_Page", Com_9001724_Page)
function Com_9001724_Page:onInit()
	self.fields.left:addClickEventListener(handler(self, self.onPageClick), -1)
	self.fields.right:addClickEventListener(handler(self, self.onPageClick), 1)
	self.fields.icon:addClickEventListener(handler(self, self.onPageClick), 0)
end
function Com_9001724_Page:onShow()
end
function Com_9001724_Page:initData(data, index, selectedIndex, pageCount)
	if data == nil then
		self.controllers.c1:setSelectedIndex(2)
	else
		self.controllers.c1:setSelectedIndex(index == selectedIndex and 1 or 0)
		local icon = data.rechargeIcon
		local title = data.rechargeTitle
		if title ~= "" then
			self.fields.title:setString(i18n(title))
		end
		self.fields.icon:setIcon(icon)
	end
	if SoraDFIsRA() then
		self.fields.left:setVisible(index < pageCount)
		self.fields.right:setVisible(1 < index)
	else
		self.fields.left:setVisible(1 < index)
		self.fields.right:setVisible(index < pageCount)
	end
	self.index = index
	self.pageCount = pageCount
	self.fields.icon:setTouchEnabled(index ~= selectedIndex)
end
function Com_9001724_Page:getIndex()
	return self.index
end
function Com_9001724_Page:setOnPageChangeCallback(callback)
	self.callback = callback
end
function Com_9001724_Page:onPageClick(event, param)
	SoraDPlaySound()
	print("Com_9001724_Page:onPageClick", self.index, param)
	if not self.index or self.index <= 0 or self.index > self.pageCount then
		return
	end
	self.callback(self.index + param)
end
return Com_9001724_Page
