local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseComponent = require("fgui.base.baseComponent")
local heroLieutenantBanner = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/heroLieutenantBanner", heroLieutenantBanner)
function heroLieutenantBanner:onInit()
	self.heroList, _UPVALUE0_, self.stateList, _UPVALUE0_, self.showList, _UPVALUE0_, self.curHeroIDList, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
	self.fields.divinebeast:setVisible(false)
	self:init()
end
function heroLieutenantBanner:onShow()
end
function heroLieutenantBanner:init()
	for i = 1, 5 do
		local heroItem = self.fields.List_lieutenant:getChildAt(i - 1):getItem()
		heroItem:setRemoveClick(handler(self, self.subCallBack))
		heroItem:setAddClick(handlerEx(self, self.addCallBack, i))
		heroItem:initData(gHeroItemLockStyle.none)
	end
end
function heroLieutenantBanner:initData(showList)
	self.showList = showList
	self:updateList()
	for i = 1, 5 do
		local heroItemObj = self.fields.List_lieutenant:getChildAt(i - 1)
		if showList[i] then
			heroItemObj:setVisible(true)
			local heroID = self.curHeroIDList[tostring(showList[i])]
			local heroItem = heroItemObj:getItem()
			if heroID then
				heroItem:initData(gHeroItemLockStyle.have, heroID)
				heroItem:showLieutenantEffect(self:isMyLieutenantHero(heroID, showList[i]))
			else
				heroItem:initData(gHeroItemLockStyle.none)
				heroItem:showLieutenantEffect(false)
			end
		else
			heroItemObj:setVisible(false)
		end
	end
end
function heroLieutenantBanner:updateList()
	local ret = clone(self.curHeroIDList)
	self.curHeroIDList, _ENV = self.curHeroIDList, self.curHeroIDList
	for _, heroID in pairs(self.showList) do
		self.curHeroIDList[tostring(heroID)] = ret[tostring(heroID)]
	end
end
function heroLieutenantBanner:subHero(heroID)
	local idx = table.keyof(self.curHeroIDList, heroID)
	if idx then
		self.curHeroIDList[idx] = nil
		self:initData(self.showList)
	else
		return false
	end
	print("sub:", heroID)
	return true
end
function heroLieutenantBanner:subHeroByIndex(mainHeroID)
	if self.curHeroIDList[tostring(mainHeroID)] then
		self.curHeroIDList[tostring(mainHeroID)] = nil
		self:initData(self.showList)
	else
		return false
	end
	print("sub:", mainHeroID)
	return true
end
function heroLieutenantBanner:addHero(heroID, mainHeroID)
	if self.curHeroIDList[tostring(mainHeroID)] ~= heroID then
		self.curHeroIDList[tostring(mainHeroID)] = heroID
		self:initData(self.showList)
	else
		return false
	end
	print("add:", heroID)
	return true
end
function heroLieutenantBanner:setParent(parent)
	self.parent = parent
end
function heroLieutenantBanner:setRemoveHandl(removeHandl)
	self.removeHandl = removeHandl
end
function heroLieutenantBanner:setLieutAddCallBack(handle)
	self.addCallBack = handle
end
function heroLieutenantBanner:subCallBack(heroID)
	if self:subHero(heroID) and self.parent and self.parent.removeHandl then
		self.parent.removeHandl(heroID)
	end
end
function heroLieutenantBanner:addCallBack(index)
	if self.addCallBack then
		self.addCallBack(index)
	end
end
function heroLieutenantBanner:exportHeros()
	return self.curHeroIDList
end
function heroLieutenantBanner:clearHeros()
	self.curHeroIDList, _UPVALUE0_ = nil, nil
end
function heroLieutenantBanner:setCurHeroIDList(curHeroIDList)
	self.curHeroIDList = curHeroIDList
end
function heroLieutenantBanner:fitEpicDispatchView(ret)
	self.controllers.c1:setSelectedIndex(ret and 1 or 0)
	self.fields.divinebeast:fixPos()
	self.fields.List_lieutenant:setPositionX(ret and SoraDFPosX(self:getWidth() / 2 - 68, self:getWidth()) or self:getWidth() / 2)
end
function heroLieutenantBanner:isMyLieutenantHero(heroID, mainHeroID)
	local dressID = heroCtrl:getHeroDressSeting(mainHeroID)
	local lieutenantHeroID = heroltCtrl:getDressLieutenant(dressID)
	return heroID == lieutenantHeroID
end
function heroLieutenantBanner:setFilteHeroState(states)
	self.stateList = states
	for i = 1, 5 do
		self.fields.List_lieutenant:getChildAt(i - 1):getItem():setFilteHeroState(self.stateList)
	end
end
function heroLieutenantBanner:checkIsDivineBeastVisble(mode)
	local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
	local isUnlock = divineBeastCtrl:getIsCanDisaptch(mode)
	self.fields.divinebeast:setVisible(isUnlock)
	return isUnlock
end
function heroLieutenantBanner:initDivineBeast(divineBeastList, mode)
	self.fields.divinebeast:refreshPanel(divineBeastList, mode)
end
return heroLieutenantBanner
