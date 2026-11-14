local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroStoryPanel = class("HeroStoryPanel", baseFguiPanel)
local charNumLine = SoraDFIsRA() and 70 or 55
local lineHeight = 24
local smallTextHeight = 440
local largeTextHeight = 705
function HeroStoryPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroStoryPanel:ctor", self.viewName)
end
function HeroStoryPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroStoryPanel:onInit()
	print("=======HeroStoryPanel:onInit")
	self.strFromToIndexList, _ENV = print, print
	self.heroID = self.proxy.param.heroID
	self.heroStoryStr = i18n(string.format("heroStory_text_%d", self.heroID))
	self.toIndex = 0
	self.pageIndex = 1
	self.fields.Com_title:initData(i18n("hero_text_117"), handler(self, self.onClickClose))
	self.fields.Book_Cover:initData(self.heroID, handler(self, self.onClickOpen))
end
function HeroStoryPanel:onShow()
	print("=======HeroStoryPanel:onShow")
	self:initData()
end
function HeroStoryPanel:onClickOpen()
	self.transitions.t0:play(1, 0, 0, -1)
end
function HeroStoryPanel:initData()
	local fromIndex = 1
	local canShowCharNum = math.floor(smallTextHeight / lineHeight * charNumLine)
	local toIndex = self:calculateByteCount(1, fromIndex + canShowCharNum - 1) - 1
	local str = string.sub(self.heroStoryStr, fromIndex, toIndex)
	_ENV = toIndex
	toIndex.toIndex = toIndex
	toIndex.heroID = self.heroID
	toIndex.showNextButton = toIndex < #self.heroStoryStr
	toIndex.showPrevButton = 1 < fromIndex
	toIndex.showImage = fromIndex == 1
	self.strFromToIndexList[self.pageIndex], toIndex.str = toIndex, str
	self.fields.Book_Page:initData(self.strFromToIndexList[self.pageIndex])
	self.toIndex = toIndex
end
function HeroStoryPanel:turnNext()
	self.isPageActReverse = false
	self.fields.Book_Page:initData(self.strFromToIndexList[self.pageIndex])
	local pageIndex = self.pageIndex + 1
	if not self.strFromToIndexList[pageIndex] then
		local fromIndex = self.toIndex + 1
		local textHeight = pageIndex == 1 and smallTextHeight or largeTextHeight
		local canShowCharNum = math.floor(textHeight / lineHeight * charNumLine)
		local toIndex = self:calculateByteCount(fromIndex, fromIndex + canShowCharNum - 1) - 1
		local str = string.sub(self.heroStoryStr, fromIndex, toIndex)
		smallTextHeight = fromIndex
		fromIndex.toIndex = toIndex
		fromIndex.heroID = self.heroID
		fromIndex.showNextButton = toIndex < #self.heroStoryStr
		fromIndex.showPrevButton = 1 < fromIndex
		fromIndex.showImage = fromIndex == 1
		self.strFromToIndexList[pageIndex], fromIndex.str = fromIndex, str
		self.fields.Book_Page2:initData(self.strFromToIndexList[pageIndex])
	end
	self.fields.Book_Page2:initData(self.strFromToIndexList[pageIndex])
	self.transitions.t1:play(1, 0, 0, -1)
	self.pageIndex = pageIndex
	self.toIndex = self.strFromToIndexList[pageIndex].toIndex
end
function HeroStoryPanel:turnPre()
	local pageIndex = self.pageIndex - 1
	if self.strFromToIndexList[pageIndex] == nil then
		return
	end
	self.isPageActReverse = false
	self.fields.Book_Page2:initData(self.strFromToIndexList[self.pageIndex])
	self.fields.Book_Page:initData(self.strFromToIndexList[pageIndex])
	self.transitions.t1:playReverse()
	self.toIndex = self.strFromToIndexList[pageIndex].toIndex
	self.pageIndex = pageIndex
end
function HeroStoryPanel:getByteCount(curByte)
	local byteCount = 1
	if 239 < curByte then
		byteCount = 4
	elseif 223 < curByte then
		byteCount = 3
	elseif 128 < curByte then
		byteCount = 2
	else
		byteCount = 1
	end
	return byteCount
end
function HeroStoryPanel:calculateByteCount(from, to)
	local index = 1
	local num = from
	for i = from, #self.heroStoryStr do
		if to <= i then
			break
		end
		local byteChar = string.byte(self.heroStoryStr, num)
		if byteChar then
			local singleNum = self:getByteCount(byteChar)
			num = num + singleNum
			index = index + 1
			if byteChar == 10 then
				to = to - math.floor(charNumLine)
			end
		else
			break
		end
	end
	return num
end
return HeroStoryPanel
