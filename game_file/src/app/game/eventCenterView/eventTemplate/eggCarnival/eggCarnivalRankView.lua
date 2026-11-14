local paintedEggCrazyCtrl = SoraDGetCtrl("paintedEggCrazyCtrl")
local eggCarnivalRead = include("eggCarnivalRead")
local madeleShareRankView = include("madeleShareRankView")
local eggCarnivalRankView = class("eggCarnivalRankView", madeleShareRankView)
function eggCarnivalRankView:ctor(...)
	eggCarnivalRankView.super.ctor(self, ...)
end
function eggCarnivalRankView:initData(rankType)
	self.type = rankType
	if self.type == gDinnerShareType.SHARE then
		self.labelDes:setString(i18n("madeleine_feast_text_10"))
		self.ccs_Title:setTitle(i18n("madeleine_feast_text_11"))
	elseif self.type == gDinnerShareType.HAPPINESS then
		self.labelDes:setString(i18n("madeleine_feast_text_12"))
		self.ccs_Title:setTitle(i18n("madeleine_feast_text_13"))
	end
	SoraDShowLoading(self)
	_ENV = i18n("madeleine_feast_text_13")
	i18n("madeleine_feast_text_13").nType = self.type
	paintedEggCrazyCtrl:reqPaintedEggCrazyShareRankData(i18n("madeleine_feast_text_13"))
end
function eggCarnivalRankView:receiveRank(data)
	eggCarnivalRankView.super.receiveRank(self, data)
end
function eggCarnivalRankView:addScrollView()
	eggCarnivalRankView.super.addScrollView(self)
end
function eggCarnivalRankView:btnJumpClickCallBack(button, EventType)
	eggCarnivalRankView.super.btnJumpClickCallBack(self, button, EventType)
end
function eggCarnivalRankView:btnClickReward(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local rankData = eggCarnivalRead.getRankOrPointRewardData(self.type, true)
		local panel = SoraDCreatePanel("commonRankAwardView")
		panel:initData(rankData)
		panel:show()
	end
end
function eggCarnivalRankView:onPlayerClick(data)
	eggCarnivalRankView.super.onPlayerClick(self, data)
end
function eggCarnivalRankView:initMyData()
	eggCarnivalRankView.super.initMyData(self)
end
return eggCarnivalRankView
