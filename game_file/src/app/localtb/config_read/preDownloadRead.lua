local preDownloadRead = include("aAReadClass").new()
preDownloadRead:defineValue("awards", function()
	local tableData = require_once("app." .. _G.LocalTblPath .. ".config_server.downloadrewards")
	if tableData and tableData[1] then
		if not tableData[1].downloadRewardDisplay then
			_ENV = tableData[1].downloadRewardDisplay
		end
		awards = tableData[1].downloadRewardDisplay
	end
	return awards
end)
function preDownloadRead.getAward()
	if not preDownloadRead.awards then
		preDownloadRead = preDownloadRead.awards
	end
	return preDownloadRead.awards
end
return preDownloadRead
