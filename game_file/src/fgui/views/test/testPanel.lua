local baseFguiPanel = require("fgui.base.baseFguiPanel")
local testPanel = class("testPanel", baseFguiPanel)
function testPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("testPanel:ctor", self.viewName)
end
function testPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "test"
	end
	return self._packageList
end
function testPanel:onInit()
	print("=======testPanel:onInit")
	self.fields.List:setOpaque(false)
	self.fields.List_activity:setOpaque(false)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_activity:setItemRenderer(handler(self, self.onActivityItemRenderer))
	self.fields.n1:setString("23432423423")
	self.fields.n1:setAlign(2)
	print("align", self.fields.n1:getTextFormat().align)
	self.listMax = self.fields.List:getHeight()
end
function testPanel:onItemRenderer(i, item)
	item:setString(self.list[i + 1][1])
	item:addClickListener(self.list[i + 1][2])
end
function testPanel:onActivityItemRenderer(index, obj)
	local data = self.activityList[index + 1]
	obj:initData(data)
end
function testPanel:onShow()
	print("======targetLow=testPanel:onShow")
	_UPVALUE2_, _UPVALUE13_ = "======targetLow=testPanel:onShow", print
	_UPVALUE1_, ("======targetLow=testPanel:onShow")[1] = "填充测试", "填充测试"
	_UPVALUE1_, ("======targetLow=testPanel:onShow")[2] = "填充测试", function()
		uiManager:show("testFill")
	end
	_UPVALUE1_, ("填充测试")[1] = "WarGemMain", "WarGemMain"
	_UPVALUE1_, ("填充测试")[2] = "WarGemMain", self:handerOpenWindow()
	_UPVALUE1_, ("填充测试")[3] = "WarGemMain", self:handerOpenWindow()
	_UPVALUE1_, ("填充测试")[4] = "WarGemMain", self:handerOpenWindow()
	_UPVALUE1_, ("填充测试")[5] = "WarGemMain", self:handerOpenWindow()
	_UPVALUE1_, ("填充测试")[6] = "WarGemMain", self:handerOpenWindow()
	_UPVALUE1_, ("填充测试")[7] = "WarGemMain", self:handerOpenWindow()
	_UPVALUE1_, ("填充测试")[8] = "WarGemMain", self:handerOpenWindow()
	_UPVALUE1_, ("填充测试")[9] = "WarGemMain", self:handerOpenWindow()
	_UPVALUE1_, ("填充测试")[10] = "WarGemMain", self:handerOpenWindow()
	_UPVALUE1_, ("填充测试")[11] = "WarGemMain", self:handerOpenWindow()
	_UPVALUE1_, ("填充测试")[12] = "WarGemMain", self:handerOpenWindow()
	_UPVALUE1_, ("填充测试")[13] = "WarGemMain", self:handerOpenWindow()
	_ENV = self:handerOpenWindow()
	self:handerOpenWindow().gemID = 12020306
	_UPVALUE2_, ("WarGemMain")[1] = "WarGemCompose", "WarGemCompose"
	_UPVALUE2_, ("WarGemMain")[2] = "WarGemCompose", self:handerOpenWindow(self:handerOpenWindow())
	_UPVALUE2_, ("WarGemMain")[3] = "WarGemCompose", self:handerOpenWindow(self:handerOpenWindow())
	_UPVALUE2_, ("WarGemMain")[4] = "WarGemCompose", self:handerOpenWindow(self:handerOpenWindow())
	_UPVALUE2_, ("WarGemMain")[5] = "WarGemCompose", self:handerOpenWindow(self:handerOpenWindow())
	_UPVALUE2_, ("WarGemMain")[6] = "WarGemCompose", self:handerOpenWindow(self:handerOpenWindow())
	_UPVALUE2_, ("WarGemMain")[7] = "WarGemCompose", self:handerOpenWindow(self:handerOpenWindow())
	_UPVALUE2_, ("WarGemMain")[8] = "WarGemCompose", self:handerOpenWindow(self:handerOpenWindow())
	_UPVALUE2_, ("WarGemMain")[9] = "WarGemCompose", self:handerOpenWindow(self:handerOpenWindow())
	_UPVALUE2_, ("WarGemMain")[10] = "WarGemCompose", self:handerOpenWindow(self:handerOpenWindow())
	_UPVALUE2_, ("WarGemMain")[11] = "WarGemCompose", self:handerOpenWindow(self:handerOpenWindow())
	_UPVALUE2_, ("WarGemMain")[12] = "WarGemCompose", self:handerOpenWindow(self:handerOpenWindow())
	_UPVALUE2_, ("WarGemCompose")[1] = "NewJourney", "NewJourney"
	_UPVALUE2_, ("WarGemCompose")[2] = "NewJourney", function()
		self:closePanel()
		uiManager:show("NewJourney")
	end
	_UPVALUE2_, ("NewJourney")[1] = "test1", "test1"
	_UPVALUE2_, ("NewJourney")[2] = "test1", function()
		uiManager:show("test1")
	end
	_UPVALUE2_, ("test1")[1] = "test2", "test2"
	_UPVALUE2_, ("test1")[2] = "test2", function()
		uiManager:show("test2")
	end
	_UPVALUE2_, ("test2")[1] = "test3", "test3"
	_UPVALUE2_, ("test2")[2] = "test3", function()
		uiManager:show("test3")
	end
	_UPVALUE2_, ("test3")[1] = "testFullView", "testFullView"
	_UPVALUE2_, ("test3")[2] = "testFullView", function()
		uiManager:show("testFullView")
	end
	_UPVALUE2_, ("testFullView")[1] = "testXYBZ", "testXYBZ"
	_UPVALUE2_, ("testFullView")[2] = "testXYBZ", function()
		uiManager:show("testXYBZ")
	end
	_UPVALUE2_, ("testXYBZ")[1] = "星云霸主预览", "星云霸主预览"
	_UPVALUE2_, ("testXYBZ")[2] = "星云霸主预览", function()
		_ENV = nil
		;(nil).testOpen = true
		uiManager:show("NebulaKingPreview", nil)
	end
	_UPVALUE2_, ("星云霸主预览")[1] = "星云霸主", "星云霸主"
	_UPVALUE2_, ("星云霸主预览")[2] = "星云霸主", function()
		uiManager:show("NebulaKingMain")
	end
	_UPVALUE2_, ("星云霸主")[1] = "星云庆典", "星云庆典"
	_UPVALUE2_, ("星云霸主")[2] = "星云庆典", function()
		uiManager:show("NebulaCelebrationMain")
	end
	;("星云庆典")[1] = "再揽星辰"
	;("星云庆典")[2] = function()
		uiManager:show("PickupStarsAgainMain")
	end
	self.activityList, _ENV, self.list, print[1] = print, print, print, "======targetLow=testPanel:onShow"
	self.activityList, _ENV, self.list, print[2] = print, print, print, "填充测试"
	self.activityList, _ENV, self.list, print[3] = print, print, print, "WarGemMain"
	self.activityList, _ENV, self.list, print[4] = print, print, print, "WarGemCompose"
	self.activityList, _ENV, self.list, print[5] = print, print, print, "NewJourney"
	self.activityList, _ENV, self.list, print[6] = print, print, print, "test1"
	self.activityList, _ENV, self.list, print[7] = print, print, print, "test2"
	self.activityList, _ENV, self.list, print[8] = print, print, print, "test3"
	self.activityList, _ENV, self.list, print[9] = print, print, print, "testFullView"
	self.activityList, _ENV, self.list, print[10] = print, print, print, "testXYBZ"
	self.activityList, _ENV, self.list, print[11] = print, print, print, "星云霸主预览"
	self.activityList, _ENV, self.list, print[12] = print, print, print, "星云霸主"
	self.activityList, _ENV, self.list, print[13] = print, print, print, "星云庆典"
	self.fields.List:setNumItems(#self.list)
	self.fields.List_activity:setNumItems(#self.activityList)
end
function testPanel:handerOpenWindow(param)
	return function(context)
		uiManager:show(context:getSender():getText(), param)
	end
end
function testPanel:onClickItem(context)
	uiManager:show(context:getSender():getText())
end
function testPanel:onHide()
	print("=======testPanel:onHide")
end
function testPanel:onDispose()
	print("=======testPanel:onDispose")
end
return testPanel
