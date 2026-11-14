local baseComponent = require("fgui.base.baseComponent")
local Com_load = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Com_load", Com_load)
function Com_load:onInit()
end
function Com_load:onShow()
end
function Com_load:initData(data)
	self:removeAllChildren()
	local node
	if data.activityID then
		node = fgui.UIPackage:createObjectFromURL("ui://MainUI/Btn_activityStyle")
		node:initData(data.activityID)
		self:addChild(node)
	else
		node = fgui.UIPackage:createObjectFromURL("ui://MainUI/" .. data.name)
		if not node then
			print("不存在组件========", data.name)
			return
		end
		if data.num and node.setRed then
			node:setRed(data.num)
		end
		if data.title then
			node:setTitle(data.title)
		end
		if data.extra then
			if node.initData then
				node:initData(data.extra)
			end
			if node.setTime and data.extra.time then
				node:setTime(data.extra.time)
			end
			if node.setIcon and data.extra.icon then
				node:setIcon(data.extra.icon)
			end
		end
		if node.setModel then
			node:setModel(data.index)
		end
		self:addChild(node)
	end
	self.btnNode = node
end
return Com_load
