local atlantisRecordDetailPop = class("atlantisRecordDetailPop", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("atlantisRecordDetailPop")
end)
_UPVALUE3_, atlantisRecordDetailPop.ctor = function(self, properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.nodeCommonTopThreeRankNode = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTopThreeRankNode")
end, function(self, properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.nodeCommonTopThreeRankNode = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTopThreeRankNode")
end
;(function(self, properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.nodeCommonTopThreeRankNode = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTopThreeRankNode")
end)[1] = "atlantiswar_text_0037"
;(function(self, properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.nodeCommonTopThreeRankNode = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTopThreeRankNode")
end)[2] = "atlantiswar_text_0038"
local (function(self, properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.nodeCommonTopThreeRankNode = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTopThreeRankNode")
end)[3], title = "atlantiswar_text_0039", function(self, properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.nodeCommonTopThreeRankNode = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTopThreeRankNode")
end
function atlantisRecordDetailPop:initData(data)
	_ENV = nil
	;(nil).num = data.season
	self.nodeCommonPopBox:setTitleName(i18n("summoned_text_29", nil))
	_ENV = i18n("summoned_text_29", nil)
	i18n("summoned_text_29", nil).var = i18n(title[data.rankData.rank])
	self.textTitle:setString(i18n("atlantiswar_text_0243", i18n("summoned_text_29", nil)))
	data.rankData.top3UserInfo.kid = data.rankData.kid
	self.nodeCommonTopThreeRankNode:initData(data.rankData.top3UserInfo)
end
return atlantisRecordDetailPop
