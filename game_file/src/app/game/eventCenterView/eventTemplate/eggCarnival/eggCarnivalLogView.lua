local paintedEggCrazyCtrl = SoraDGetCtrl("paintedEggCrazyCtrl")
local madeleLogView = include("madeleLogView")
local eggCarnivalLogView = class("eggCarnivalLogView", madeleLogView)
function eggCarnivalLogView:onEnterPanel()
	print("reqPaintedEggCrazyShareDoneeRecordRsp")
	paintedEggCrazyCtrl:reqPaintedEggCrazyShareDoneeRecord()
	SoraDShowLoading(self)
	self.mergeItem = 838301
end
function eggCarnivalLogView:ctor(...)
	eggCarnivalLogView.super.ctor(self, ...)
end
function madeleLogView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MADELE_LOG_SUCCESS", function(target, data)
		SoraDCloseLoading(self)
		if data.data and table.nums(data.data) > 0 then
			self:initData(data.data)
		else
			local text = ccui.Text:create(i18n("common_text_927"), "", 20)
			text:addTo(SoraDGetChildByName(self, "Center_Node"))
			text:setPosition(0, 0)
		end
	end)
end
function eggCarnivalLogView:getTimeNode()
	return eggCarnivalLogView.super.getTimeNode(self)
end
function eggCarnivalLogView:getSingleNode()
	return eggCarnivalLogView.super.getSingleNode(self)
end
function eggCarnivalLogView:initData(data)
	eggCarnivalLogView.super.initData(self, data)
end
function eggCarnivalLogView:onPlayerClick(target, event)
	eggCarnivalLogView.super.onPlayerClick(self, target, event)
end
function eggCarnivalLogView:initPlayer(target, data)
	eggCarnivalLogView.super.initPlayer(self, target, data)
end
return eggCarnivalLogView
