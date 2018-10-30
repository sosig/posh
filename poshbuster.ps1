param (
  [string]$baseurl,
  [string]$mode
)

$directories = @(
    "cgi-bin-sdb","cgi-bin","cgi-local","cgi-sys","cgi-shl","cgi-win","cgi","cgi-bin-sdb/printenv","cgi-bin/authLogin","cgi-bin/cgiinfo","cgi-bin/cgitest","cgi-bin/env","cgi-bin/environment",
    "cgi-bin/ezmlm-browse","cgi-bin/helpme","cgi-bin/hi","cgi-bin/his","cgi-bin/index","cgi-bin/info","cgi-bin/php","cgi-bin/php-cgi","cgi-bin/php4","cgi-bin/php5","cgi-bin/printenv","cgi-bin/restore_config",
    "cgi-bin/ruby","cgi-bin/search","cgi-bin/server","cgi-bin/status","cgi-bin/test","cgi-bin/test-cgi","cgi-bin/viewcvs","cgi-bin/welcome","cgi-bin/whois","cgi-mod","cgi-sys/FormMail-clone","cgi-sys/defaultwebpage",
    "cgi-sys/index","cgi-sys/php","cgi-sys/php5","uname","ifconfig","pwd","id","shell","command","cmd","exe","exec",
    "executable","admin","administrate","adminstrator","manage","manager","network","bash","sh","ls","less","ping",
    "pingit","ping_it","netstat","icons","images","manual","portmap","code","gateway","users","passwords","passwd",
    "shadow","python","py","java","js","script","scripts","schtasks","cron","term","terminal","xterm",
    "unix","linux","windows","dc","ad","domain","network","icons","config","configure","conf","com",
    "comm","corp","email","ps","powershell","process","power","rb","ruby","pl","perl","ps1",
    "scripting","console","panel","sched","schedule","secire","secret","secrets","robot","robots","botnet","reverse",
    "include","includes","import","download","upload","upl","update","upgrade","reconfig",
    "g00nshell","fatal","ironshell","kral","lamashell","myshell","megabor","lostDC","php-backdoor","php-reverse-shell","simple-php-backdoor","backdoor",
    "jaws","ex0shell","erne","ftpsearch","ftp","sftp","ftps","ssh","webssh","nshell","simple-backdoor","simple_cmd",
    "rootshell","root","s72_shell_v1.1_coding","simattacker","safe0ver","stres","zaco","pentest","hacked","h@ck3d","1337","testing",
    "doorway","door","coding","dev","develop","deploy","forum","login","logout","join","exit","default",
    "a","aa","aaa","b","bb","bbb","abc","def","aba","aab","baa","cba",
    "git","github","gitlab","splunk","aws","webapp","servlet","jsp","msf","msfrpc","wifi","util",
    "sym","sim","proc","poc","srv","svc","inf","tech","rx","tx","client","ident",
    "3com","apc","rpc","account","database","db","mysql","mssql","db2","domino","lotus","post",
    "postgresql","pgsql","psql","list","api","restful","rest","wiki","wp","wordp","wordpress","wp-admin",
    "wp-login","wp-forum","wpress","apache","at","lambda","ecs","s3","gsm","generic","nessus","tenable",
    "vuln","vulnerable","vulnerabilities","dvwa","webgoat","php","php4","php5","phpinfo","myphpadmin","uploads","content"
)
$extensions = @('.txt','.asp','.aspx','.jpeg','.jpg','.png','.bmp','.iso','.exe','.ico','.img','.jsp','.cgi','.py','.html','.php','.action','.do','.rb','.xml','')
$global:existing = @()

function iterate_dirs($url,$dirs)
{
    foreach ($d in $dirs)
    {
        foreach ($e in $extensions)
        {
            $target = $($url+'/'+$d+$e)
            $ie = [System.Net.WebRequest]::Create($target)
            try {
                $ie.getresponse() | Out-Null
                write-host "[*] Discovered "$target -ForegroundColor Green
                if ($e.contains('.'))
                {
                    continue
                }
                else
                {
                    $global:existing += $target
                }
            }
            catch{continue}
        }
    }
}
iterate_dirs $baseurl $directories
if ($('recurse').Contains($mode))
{
    while ($true)
    {
        if ($global:existing.Length -eq 0)
        {
            write-host '[#] Exiting' -ForegroundColor Red
            break
        }
        else
        {
            foreach ($directory in $global:existing)
            {
                write-host '[#] Testing for subdirectories in '$directory -ForegroundColor Green
                iterate_dirs $directory $directories
                $global:existing = $global:existing | Where-Object {$_ -ne $directory}
            }
        }
    }
}