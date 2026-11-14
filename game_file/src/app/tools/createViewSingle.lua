local gametop = gModuleMgr.getObject("gametop")
local createViewSingle = class("createViewSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("createViewSingle")
	end
	return target
end)
_ENV, _UPVALUE4_ = function(target)
	if target == nil then
		return SoraDCreateBasePanel("createViewSingle")
	end
	return target
end, "createViewSingle"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("createViewSingle")
	end
	return target
end).property = "load"
_ENV, (function(target)
	if target == nil then
		return SoraDCreateBasePanel("createViewSingle")
	end
	return target
end).name = nil, "是否加载"
;(nil).property = "loadClick"
_ENV, (nil).name = nil, "事件注册"
;(nil).property = "autoScroll"
_ENV, (nil).name = nil, "autoScroll"
;(nil).property = "textTime"
;(nil).name = "活动时间"
;("createViewSingle")[1] = function(target)
	if target == nil then
		return SoraDCreateBasePanel("createViewSingle")
	end
	return target
end
;("createViewSingle")[2] = nil
;("createViewSingle")[3] = nil
local ("createViewSingle")[4], tableItem = nil, "createViewSingle"
function createViewSingle:ctor()
	self.info, _ENV = nil, nil
	self.panleTouch = SoraDGetChildByName(self, "Panel_touch")
	self.panleTouch:setTouchEnabled(true)
	self.panleTouch:setSwallowTouches(false)
	self.panleTouch:addTouchEventListener(handler(self, self.btnPanelClick))
	self.spArr = SoraDGetChildByName(self, "Sprite_arr")
	self.textName = SoraDGetChildByName(self, "Text_Name")
	self.checkBox = SoraDGetChildByName(self, "CheckBox")
	self.checkBox:addEventListener(handler(self, self.btnCheckClickCallBack))
end
function createViewSingle:initData(info, otherInfo)
	self.chooseIndex = 1
	self.info = info
	local panel_pagramer = include("commonDropBox").new()
	_ENV = nil
	;(nil).width = 180
	;(nil).singleWidth = 130
	;(nil).showPanelHeight = 350
	;(nil).sliderHeight = 250
	panel_pagramer:initConfig(nil)
	panel_pagramer:initData(tableItem)
	panel_pagramer:setPosition(cc.p(300, 60))
	panel_pagramer:addTo(self, 9)
	panel_pagramer:setHandleChoose(function(target, index, data)
		self.chooseIndex = index
		self.checkBox:setSelected(self.info[tableItem[self.chooseIndex].property])
	end)
	panel_pagramer:initView()
	self.parentView = otherInfo.view
	self.scroll = otherInfo.scroll
	self.checkBox:setSelected(self.info[tableItem[self.chooseIndex].property])
	self.textName:setString(info.name)
	self.textName:setPositionX(30 * info.level)
	self.spArr:setVisible(info.allChildrenNum > 0)
	self.showChild = info.showChild
	self.spArr:setRotation(info.showChild and 0 or -90)
end
function createViewSingle:btnCheckClickCallBack(target, eventType)
	SoraDPlaySound()
	self.parentView:setPByIndexAndKey(tableItem[self.chooseIndex].property, self.info.index, eventType == ccui.CheckBoxEventType.selected)
end
function createViewSingle:btnPanelClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		self.showChild = not self.showChild
		if not self.info.childrenIndex then
			return
		end
		if self.showChild then
			self.parentView:setPByIndexAndKey("showChild", self.info.index, self.showChild)
			self.parentView:addViewChildrenData(self.info.childrenIndex)
		else
			self.parentView:setPByIndexAndKey("showChild", self.info.index, self.showChild)
			self.parentView:removeViewChildrenData(self.info.childrenIndex)
		end
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return createViewSingle
