set language us_english
declare @s varchar(max)
declare @c varchar(max)

set @s = ''
set @c = ''

select @c = count(*) from tbComputerTarget, tbComputerSummaryForMicrosoftUpdates where tbComputerTarget.TargetID = tbComputerSummaryForMicrosoftUpdates.TargetID and tbComputerSummaryForMicrosoftUpdates.InstalledPendingReboot > 0
select @s = '<table cellpadding=3 cellspacing=0 border=1><tr style="color:White;background-color:SteelBlue;font-weight:bold;"><td>FullDomainName</td>' +
'<td>IPAddress</td><td>InstalledPendingReboot</td><td>LastReportedRebootTime</td></tr>' +
cast ((
select top 1000 [Tag] = 1, [Parent] = 0, 
[tr!1!td!element] = [FullDomainName], 
[tr!1!td!element] = [IPAddress], 
[tr!1!td!element] = [InstalledPendingReboot],
[tr!1!td!element] = convert(varchar,[LastReportedRebootTime],113)
from tbComputerTarget, tbComputerSummaryForMicrosoftUpdates where tbComputerTarget.TargetID = tbComputerSummaryForMicrosoftUpdates.TargetID and tbComputerSummaryForMicrosoftUpdates.InstalledPendingReboot > 0 order by LastReportedRebootTime
for xml explicit
) as varchar(max) ) 
+ '<tr><td>Totals</td><td></td><td></td><td>'+CONVERT(varchar,@c) + '</td></tr></table>'


EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'user_not',
  @recipients = 'administrator@domain.com',
  @subject = 'Pending reboot',
  @body = @s,
  @body_format = 'HTML' ;