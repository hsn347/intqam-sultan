local gametop = gModuleMgr.getObject("gametop")
local publicRead = include("publicRead")
local legendRewardItem = class("legendRewardItem", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("legendRewardItem")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function legendRewardItem:ctor()
	self:createUI()
	self.textDes = SoraDGetChildByName(self, "text_des")
	self.textNum = SoraDGetChildByName(self, "text_num")
	local nodeItem = SoraDGetChildByName(self, "nodeItem")
	self.commonItemNode = include("commonItemAward").new(nodeItem)
end
function legendRewardItem:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function legendRewardItem:initData(data)
	self.data = data
	self.commonItemNode:initData(self.data.id)
	local strName = publicRead.getName(self.data.id)
	self.textDes:setString(strName)
	self.textNum:setString(string.formatnumberthousands(self.data.count))
end
function legendRewardItem:onMessageListener()
end
function legendRewardItem:setScroll(scroll)
	self.scroll = scroll
	self.commonItemNode:setOwnScroll(scroll)
end
function legendRewardItem:setView(view)
	self.commonItemNode:setOwnView(view)
end
return legendRewardItem
