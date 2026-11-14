local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroLieutenantBanner = class("heroLieutenantBanner", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroLieutenantBanner")
	end
	return target
end)
function heroLieutenantBanner:ctor()
	self.stateList, _ENV, self.showList, _ENV, self.curHeroIDList, _ENV = nil, nil, nil, nil, nil, nil
	self.nodeExplain = SoraDGetChildByName(self, "Node_Explain")
	self.nodeExplain:setVisible(false)
	self.nodeList = SoraDGetChildsArrayByName(self, "Node_", 5, 1)
	self.heroItemList = SoraDGetChildsArrayByName(self, "CCS_heroLockItem_", 5, 1, true, true)
	self.textTitle = SoraDGetChildByName(self.nodeExplain, "Text_Title")
	self.textTitle:setString(i18n("lieutenant_text_01"))
	self.btnQuest = SoraDGetChildByName(self.nodeExplain, "Button_Question")
	self.btnQuest:addTouchEventListener(handler(self, self.onClickQuestion))
	self.nodeDivineBeast = SoraDGetExtendChildFromCCSByName(self, "CCS_heroSelectDivinebeast")
	self.nodeDivineBeast:setVisible(true)
	self:init()
end
function heroLieutenantBanner:init()
	for i, heroItem in ipairs(self.heroItemList) do
		heroItem:setRemoveClick(handler(self, self.subCallBack))
		heroItem:setAddClick(handlerEx(self, self.addCallBack, i))
		heroItem:initData(gHeroItemLockStyle.none)
	end
end
function heroLieutenantBanner:initData(showList)
	self.showList = showList
	self:updateList()
	for i, node in ipairs(self.nodeList) do
		if showList[i] then
			node:setVisible(true)
			local heroID = self.curHeroIDList[tostring(showList[i])]
			if heroID then
				self.heroItemList[i]:initData(gHeroItemLockStyle.have, heroID)
				self.heroItemList[i]:showLieutenantEffect(self:isMyLieutenantHero(heroID, showList[i]))
			else
				self.heroItemList[i]:initData(gHeroItemLockStyle.none)
				self.heroItemList[i]:showLieutenantEffect(false)
			end
		else
			node:setVisible(false)
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
function heroLieutenantBanner:onClickQuestion(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("lieutenant_text_10"))
	end
end
function heroLieutenantBanner:subHero(heroID)
	local idx = table.keyof(self.curHeroIDList, heroID)
	if idx then
		self.curHeroIDList[idx] = nil
		self:initData(self.showList)
	else
		print("无英雄")
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
		print("无英雄")
		return false
	end
	print("sub:", heroID)
	return true
end
function heroLieutenantBanner:addHero(heroID, mainHeroID)
	dump(self.curHeroIDList, "self.curHeroIDList")
	if self.curHeroIDList[tostring(mainHeroID)] ~= heroID then
		self.curHeroIDList[tostring(mainHeroID)] = heroID
		self:initData(self.showList)
	else
		print("重复添加")
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
	if self:subHero(heroID) and self.parent.removeHandl then
		self.parent.removeHandl(heroID)
	end
end
function heroLieutenantBanner:addCallBack(index)
	print("heroLieutenantBanner:addCallBack-index", index)
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
function heroLieutenantBanner:fitEpicDispatchView()
	for i, v in ipairs(self.nodeList) do
		v:setPositionX(SoraDFSign(250 - (i - 1) * 125))
	end
	self.nodeExplain:setVisible(false)
end
function heroLieutenantBanner:isMyLieutenantHero(heroID, mainHeroID)
	local dressID = heroCtrl:getHeroDressSeting(mainHeroID)
	local lieutenantHeroID = heroltCtrl:getDressLieutenant(dressID)
	return heroID == lieutenantHeroID
end
function heroLieutenantBanner:setFilteHeroState(states)
	self.stateList = states
	for i, heroItem in ipairs(self.heroItemList) do
		heroItem:setFilteHeroState(self.stateList)
	end
end
function heroLieutenantBanner:checkIsDivineBeastVisble(mode)
	local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
	local isUnlock = divineBeastCtrl:getIsCanDisaptch(mode)
	self.nodeDivineBeast:setVisible(isUnlock)
	return isUnlock
end
function heroLieutenantBanner:initDivineBeast(divineBeastList, mode)
	self.nodeDivineBeast:refreshPanel(divineBeastList, mode)
end
return heroLieutenantBanner
