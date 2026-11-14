local remainsWarRankHistorySingle = class("remainsWarRankHistorySingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("remainsWarRankHistorySingle")
	end
	return target
end)
function remainsWarRankHistorySingle:ctor()
	self.txtDate = SoraDGetChildByName(self, "Text_date")
	self.txtScore = SoraDGetChildByName(self, "Text_score")
	self.spFlagSuc = SoraDGetChildByName(self, "Sprite_flag_suc")
	self.spFlagFail = SoraDGetChildByName(self, "Sprite_flag_fail")
	self.Button_record = SoraDGetChildByName(self, "Button_record")
	self.Button_record:addTouchEventListener(handler(self, self.onBtnRecordClick))
	self.tableSingleData, _ENV, self.Image_bg = SoraDGetChildByName(self, "Image_bg"), SoraDGetChildByName(self, "Image_bg"), SoraDGetChildByName(self, "Image_bg")
end
function remainsWarRankHistorySingle:initData(data)
	self.tableSingleData = data
	self:updateInfo()
end
local formatScore = function(score)
	if score == 0 then
		return "-"
	end
	return string.format("%+d", score)
end
function remainsWarRankHistorySingle:updateInfo()
	local timeStr = os.date([[
!%Y/%m/%d 
%H:%M:%S]], self.tableSingleData.time)
	self.txtDate:setString(timeStr)
	self.txtScore:setString(formatScore(self.tableSingleData.addScore))
	local isWin = self.tableSingleData.isWin
	self.spFlagSuc:setVisible(isWin)
	self.spFlagFail:setVisible(not isWin)
	local showRecord = self.tableSingleData.isNew
	self.Button_record:setVisible(showRecord)
	if isWin then
		SoraChangeSpriteImage(self.Image_bg, "frame_yjzz_newbg_06.png")
	else
		SoraChangeSpriteImage(self.Image_bg, "frame_yjzz_newbg_05.png")
	end
end
function remainsWarRankHistorySingle:onBtnRecordClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowLoading()
		SoraDGetCtrl("remainsTeamCtrl"):reqHistoryRecordInfo(self.tableSingleData.rank)
	end
end
return remainsWarRankHistorySingle
