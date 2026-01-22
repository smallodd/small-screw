<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>${title!'数据库设计文档'}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --secondary: #7209b7;
            --bg: #f8fafc;
            --border: #e2e8f0;
            --dark: #1e293b;
            --gray: #64748b;
            --light: #eef2ff;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Arial;
            background: var(--bg);
            color: var(--dark);
        }

        /* ===== 布局 ===== */
        .layout {
            display: flex;
        }

        /* ===== 左侧目录 ===== */
        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 280px;
            height: 100vh;
            background: #fff;
            border-right: 1px solid var(--border);
            padding: 20px;
            overflow-y: auto;
        }

        .sidebar h2 {
            font-size: 18px;
            margin-bottom: 12px;
        }

        .search-box {
            margin-bottom: 12px;
        }

        .search-box input {
            width: 100%;
            padding: 8px 10px;
            border-radius: 6px;
            border: 1px solid var(--border);
        }

        .catalog {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .catalog li a {
            display: block;
            padding: 6px 10px;
            border-radius: 6px;
            color: var(--dark);
            text-decoration: none;
            font-size: 14px;
        }

        .catalog li a:hover {
            background: var(--light);
        }

        .catalog li a.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
        }

        /* ===== 右侧内容 ===== */
        .content {
            margin-left: 280px;
            padding: 24px;
            width: calc(100% - 280px);
        }

        .header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
            padding: 32px;
            border-radius: 10px;
            margin-bottom: 24px;
            text-align: center;
        }

        .section {
            background: #fff;
            border-radius: 10px;
            margin-bottom: 30px;
            padding: 24px;
            box-shadow: 0 10px 15px -8px rgba(0,0,0,.15);
        }

        .section-title {
            font-size: 20px;
            margin-bottom: 16px;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }

        th, td {
            border-bottom: 1px solid var(--border);
            padding: 10px;
            text-align: center;
            font-size: 14px;
        }

        thead {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
        }

        tbody tr:hover { background: var(--light); }

        td:nth-child(2) { text-align: left; }
        td:nth-child(3) { font-family: monospace; background: #f6f8fa; }

        .badge {
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .yes { background: #d1fae5; color: #065f46; }
        .no { background: #fee2e2; color: #991b1b; }
        .pk { background: #fef3c7; color: #92400e; }

        /* 默认值 hover */
        .default-cell {
            max-width: 200px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            position: relative;
        }

        .default-cell:hover::after {
            content: attr(data-full);
            position: absolute;
            left: 0;
            top: 100%;
            background: #1e293b;
            color: #fff;
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 12px;
            white-space: normal;
            z-index: 99;
            max-width: 400px;
        }
    </style>
</head>

<body>

<div class="layout">

    <!-- ===== 左侧目录 ===== -->
    <aside class="sidebar">
        <h2><i class="fas fa-book"></i> 数据表目录</h2>

        <div class="search-box">
            <input type="text" id="search" placeholder="搜索表名…">
        </div>

        <ul class="catalog" id="catalog">
            <#list tables as t>
                <li>
                    <a href="#table-${t.tableName}" data-name="${t.tableName}">
                        ${t.tableName}
                    </a>
                </li>
            </#list>
        </ul>
    </aside>

    <!-- ===== 右侧内容 ===== -->
    <main class="content">

        <div class="header">
            <h1><i class="fas fa-database"></i> ${title!'数据库设计文档'}</h1>
        </div>

        <#list tables as t>
            <div class="section" id="table-${t.tableName}">
                <div class="section-title">
                    <i class="fas fa-table"></i> ${t.tableName}
                </div>

                <table>
                    <thead>
                    <tr>
                        <th width="60">序号</th>
                        <th>字段名</th>
                        <th>类型</th>
                        <th>小数位</th>
                        <th>可空</th>
                        <th>PK</th>
                        <th>默认值</th>
                        <th>说明</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list t.columns as c>
                        <tr>
                            <td>${c?index + 1}</td>
                            <td>${c.columnName!''}</td>
                            <td>${c.columnType!''}</td>
                            <td>${c.decimalDigits!'0'}</td>
                            <td>
                                <#if c.nullable == 'Y'>
                                    <span class="badge yes">是</span>
                                <#else>
                                    <span class="badge no">否</span>
                                </#if>
                            </td>
                            <td>
                                <#if c.primaryKey == 'Y'>
                                    <span class="badge pk">PK</span>
                                <#else>-</#if>
                            </td>
                            <td class="default-cell" data-full="${c.columnDef!''}">
                                ${c.columnDef!'-'}
                            </td>
                            <td>${c.remarks!''}</td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </#list>

    </main>
</div>

<script>
    /* 搜索表名 */
    document.getElementById('search').addEventListener('input', function () {
        const keyword = this.value.toLowerCase();
        document.querySelectorAll('#catalog a').forEach(a => {
            const name = a.dataset.name.toLowerCase();
            a.parentElement.style.display = name.includes(keyword) ? '' : 'none';
        });
    });

    /* 当前表高亮 */
    const links = document.querySelectorAll('#catalog a');
    const sections = [...document.querySelectorAll('.section')];

    window.addEventListener('scroll', () => {
        let current = '';
        sections.forEach(sec => {
            if (window.scrollY >= sec.offsetTop - 120) {
                current = sec.id;
            }
        });

        links.forEach(a => {
            a.classList.toggle('active', a.getAttribute('href') === '#' + current);
        });
    });
</script>

</body>
</html>
