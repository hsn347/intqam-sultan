local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonCongratulationsPanel = class("CommonCongratulationsPanel", baseFguiPanel)
function CommonCongratulationsPanel:ctor(...)
	CommonCongratulationsPanel.super.ctor(self, ...)
	self.debug = true
	print("CommonCongratulationsPanel:ctor", self.viewName)
	self.resetDefaultItem = true
	self.scrollH = 0
end
function CommonCongratulationsPanel:getPackageList(...)
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonBoxSingle"
	end
	return self._packageList
end
function CommonCongratulationsPanel:onInit()
	print("=======CommonCongratulationsPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function CommonCongratulationsPanel:onShow()
	print("=======CommonCongratulationsPanel:onShow")
	if not self.param then
		local _ENV, param = self.param, self.param
	end
	self.itemType = param.itemType or 1
	if not param.rewards then
		_ENV = param.rewards
	end
	self.awardList = param.rewards
	self.showGetRewards = param.rewards2
	if self.resetDefaultItem then
		self:setDefaultItem()
	end
	if param.width then
		self.fields.List:setWidth(param.width)
	end
	self.fields.List:setNumItems(#self.awardList)
	local totalSize = self.fields.List:getInnerContainerSize()
	local totalH = totalSize.height
	local maxH = 646
	local scrollH = math.min(totalH, maxH)
	self.fields.List:setHeight(scrollH)
	if totalH > maxH then
		self.fields.List:setScrollEnable(true)
	else
		self.fields.List:setScrollEnable(false)
	end
	_ENV = false
	;(false).scrollH = scrollH
	self.fields.Com_base:initBaseData(false)
	self.scrollH = scrollH
end
function CommonCongratulationsPanel:setDefaultItem()
	_UPVALUE2_, _ENV = nil, nil
	_UPVALUE2_, (nil)[1], (nil)[1] = nil, nil, "CommonNew"
	_UPVALUE2_, (nil)[1], (nil)[2] = nil, nil, "ui://CommonNew/Com_item100"
	_UPVALUE2_, (nil)[2], (nil)[1] = nil, nil, "CommonBoxSingle"
	_UPVALUE2_, (nil)[2], (nil)[2] = nil, nil, "ui://CommonBoxSingle/Com_itemWithTimes"
	_UPVALUE2_, (nil)[3], (nil)[1] = nil, nil, "Activity_9001619"
	_UPVALUE2_, (nil)[3], (nil)[2] = nil, nil, "ui://Activity_9001619/Activity_9001619_Node_single"
	_UPVALUE2_, (nil)[4], (nil)[1] = nil, nil, "Activity_9001630"
	_UPVALUE2_, (nil)[4], (nil)[2] = nil, nil, "ui://Activity_9001630/Activity_9001630_single2"
	;(nil)[5], (nil)[1] = nil, "Activity_9001649"
	;(nil)[5], (nil)[2] = nil, "ui://Activity_9001649/Com_9001649_Ten"
	local config
	local cfg = config[self.itemType] or config[1]
	fguiHelper.addPackage(self, cfg[1])
	local defaultItem = cfg[2]
	self.fields.List:setDefaultItem(defaultItem)
end
function CommonCongratulationsPanel:onItemRederer(index, obj)
	local data = self.awardList[index + 1]
	if self.itemType == 1 then
		self:updateItemType1(obj, data)
	elseif self.itemType == 2 then
		self:updateItemType2(obj, data, index)
	elseif obj.initData then
		obj:initData(data)
	end
end
function CommonCongratulationsPanel:updateItemType1(obj, data)
	obj:initData(data.id, data.count)
end
function CommonCongratulationsPanel:updateItemType2(obj, data, index)
	local _fields = fguiHelper.get_fields(obj)
	_ENV = nil
	;(nil).num = index + 1
	_fields.Text_times:setString(i18n("petra_text_07", nil))
	_fields.Com_item:initData(data.id, data.count)
end
function CommonCongratulationsPanel:onHide()
	if self.showGetRewards and #self.showGetRewards > 0 then
		SoraDMailGainItems(self.showGetRewards, true)
	end
end
return CommonCongratulationsPanel
