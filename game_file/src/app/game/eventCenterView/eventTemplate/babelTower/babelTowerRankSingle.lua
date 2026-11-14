local babelTowerRankSingle = class("babelTowerRankSingle", function(luaFileName)
	local target = include("commonRankingSingle").new("babelTowerRankSingle")
	return target
end)
function babelTowerRankSingle:ctor(properties)
	self.textTime = SoraDGetChildByName(self, "Text_Time")
end
function babelTowerRankSingle:initData_imp(data, otherData)
	self.textTime:setString(os.date("!%Y-%m-%d %H:%M:%S", data.time))
	self:initData(data, otherData)
end
return babelTowerRankSingle
