<#--

    screw-core - 简洁好用的数据库表结构文档生成工具
    Copyright © 2020 SanLi (qinggang.zuo@gmail.com)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

-->
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title!'数据库设计文档'}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style type='text/css'>
        :root {
            --primary-color: #4361ee;
            --primary-light: #eef2ff;
            --secondary-color: #7209b7;
            --accent-color: #4cc9f0;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --dark-color: #1e293b;
            --light-color: #f8fafc;
            --gray-color: #64748b;
            --border-color: #e2e8f0;
            --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.1);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            --radius-sm: 0.375rem;
            --radius-md: 0.5rem;
            --radius-lg: 0.75rem;
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            font-size: 14px;
            line-height: 1.6;
            color: var(--dark-color);
            background-color: var(--light-color);
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
        }

        /* Header Styles */
        .header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 40px 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: "";
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 20px 20px;
            opacity: 0.2;
            z-index: 0;
        }

        .header-content {
            position: relative;
            z-index: 1;
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .header h1 i {
            font-size: 2.2rem;
            background: rgba(255, 255, 255, 0.2);
            padding: 15px;
            border-radius: 50%;
        }

        .metadata {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: var(--radius-md);
            padding: 20px;
            margin-top: 30px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            text-align: left;
            backdrop-filter: blur(10px);
        }

        .metadata-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .metadata-item i {
            font-size: 1.2rem;
            opacity: 0.9;
        }

        .metadata-label {
            font-weight: 600;
            min-width: 80px;
        }

        .metadata-value {
            flex: 1;
        }

        /* Index Table Styles */
        .section {
            padding: 30px;
            border-bottom: 1px solid var(--border-color);
        }

        .section:last-child {
            border-bottom: none;
        }

        .section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--primary-light);
        }

        .section-title i {
            font-size: 1.3rem;
        }

        .table-container {
            overflow-x: auto;
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 600px;
        }

        thead {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            color: white;
        }

        thead th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        tbody tr {
            border-bottom: 1px solid var(--border-color);
            transition: var(--transition);
        }

        tbody tr:hover {
            background-color: var(--primary-light);
        }

        tbody td {
            padding: 15px;
            vertical-align: top;
        }

        /* Table of Contents */
        .toc-table tbody td:first-child {
            text-align: center;
            font-weight: 600;
            color: var(--gray-color);
            width: 60px;
        }

        .toc-table tbody td:nth-child(2) a {
            color: var(--primary-color);
            font-weight: 500;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: var(--transition);
        }

        .toc-table tbody td:nth-child(2) a:hover {
            color: var(--secondary-color);
            transform: translateX(5px);
        }

        .toc-table tbody td:nth-child(2) a i {
            font-size: 0.9rem;
            opacity: 0.7;
        }

        /* Table Detail Styles */
        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
            padding: 20px;
            background-color: var(--primary-light);
            border-radius: var(--radius-md);
            border-left: 5px solid var(--primary-color);
        }

        .table-info h3 {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .table-info h3 i {
            font-size: 1.1rem;
        }

        .table-description {
            color: var(--gray-color);
            font-style: italic;
            margin-top: 5px;
        }

        .back-to-top {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 15px;
            background-color: white;
            color: var(--primary-color);
            text-decoration: none;
            border-radius: var(--radius-sm);
            font-weight: 500;
            border: 1px solid var(--border-color);
            transition: var(--transition);
            white-space: nowrap;
        }

        .back-to-top:hover {
            background-color: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Column Table Styles */
        .column-table thead th {
            text-align: center;
        }

        .column-table tbody td {
            text-align: center;
            padding: 12px 15px;
        }

        .column-table tbody td:first-child {
            font-weight: 600;
            color: var(--gray-color);
        }

        .column-table tbody td:nth-child(2) {
            text-align: left;
            font-weight: 500;
            color: var(--dark-color);
        }

        .column-table tbody td:nth-child(3) {
            font-family: 'Courier New', monospace;
            background-color: #f6f8fa;
            border-radius: var(--radius-sm);
            font-weight: 500;
        }

        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-yes {
            background-color: #d1fae5;
            color: #065f46;
        }

        .badge-no {
            background-color: #fee2e2;
            color: #991b1b;
        }

        .badge-null {
            background-color: #e0e7ff;
            color: #3730a3;
        }

        .badge-pk {
            background-color: #fef3c7;
            color: #92400e;
        }

        /* Footer Styles */
        footer {
            background-color: var(--dark-color);
            color: white;
            padding: 30px;
            text-align: center;
            margin-top: 40px;
        }

        .footer-content {
            max-width: 800px;
            margin: 0 auto;
        }

        .footer-content a {
            color: var(--accent-color);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }

        .footer-content a:hover {
            color: white;
            text-decoration: underline;
        }

        .footer-info {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
            margin-top: 15px;
        }

        .footer-info i {
            font-size: 1.5rem;
            color: var(--accent-color);
        }

        /* 浮动返回顶部按钮 */
        .floating-top-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 50px;
            height: 50px;
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            box-shadow: var(--shadow-lg);
            transition: var(--transition);
            z-index: 100;
            opacity: 0;
            visibility: hidden;
            transform: translateY(20px);
        }

        .floating-top-btn.visible {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .floating-top-btn:hover {
            transform: translateY(-5px) scale(1.1);
            box-shadow: 0 10px 20px rgba(67, 97, 238, 0.3);
        }

        .floating-top-btn i {
            font-size: 1.2rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .header {
                padding: 30px 20px;
            }

            .header h1 {
                font-size: 1.8rem;
                flex-direction: column;
                gap: 10px;
            }

            .metadata {
                grid-template-columns: 1fr;
                padding: 15px;
            }

            .section {
                padding: 20px;
            }

            .table-header {
                flex-direction: column;
                gap: 15px;
            }

            .back-to-top {
                align-self: flex-start;
            }

            thead th, tbody td {
                padding: 10px;
            }

            .floating-top-btn {
                bottom: 20px;
                right: 20px;
                width: 45px;
                height: 45px;
            }
        }

        @media print {
            .back-to-top, .floating-top-btn {
                display: none;
            }

            .container {
                box-shadow: none;
            }
        }
    </style>
</head>
<body>
<div class='container'>
    <!-- Header Section -->
    <div class='header' id='top'>
        <div class='header-content'>
            <h1><i class='fas fa-database'></i> ${title!'数据库设计文档'}</h1>
            <div class='metadata'>
                <div class='metadata-item'>
                    <i class='fas fa-database'></i>
                    <span class='metadata-label'>数据库名：</span>
                    <span class='metadata-value'>${database!''}</span>
                </div>
                <#if (version)??>
                    <div class='metadata-item'>
                        <i class='fas fa-code-branch'></i>
                        <span class='metadata-label'>文档版本：</span>
                        <span class='metadata-value'>${version!''}</span>
                    </div>
                </#if>
                <#if (description)??>
                    <div class='metadata-item'>
                        <i class='fas fa-file-alt'></i>
                        <span class='metadata-label'>文档描述：</span>
                        <span class='metadata-value'>${description!''}</span>
                    </div>
                </#if>
                <#if (tables)??>
                    <div class='metadata-item'>
                        <i class='fas fa-table'></i>
                        <span class='metadata-label'>数据表数：</span>
                        <span class='metadata-value'>${tables?size}</span>
                    </div>
                </#if>
            </div>
        </div>
    </div>

    <!-- Table of Contents -->
    <div class='section'>
        <div class='section-title'>
            <i class='fas fa-list'></i> 数据表目录
        </div>
        <div class='table-container'>
            <table class='toc-table'>
                <thead>
                <tr>
                    <th style='width:60px;'>序号</th>
                    <th>表名</th>
                    <th>说明</th>
                </tr>
                </thead>
                <tbody>
                <#list tables>
                    <#items as t>
                        <tr>
                            <td>${t?index+1}</td>
                            <td>
                                <a href='#table-${t.tableName}'>
                                    <i class='fas fa-table'></i> ${t.tableName}
                                </a>
                            </td>
                            <td>${t.remarks!''}</td>
                        </tr>
                    </#items>
                </#list>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Table Details -->
    <#list tables>
        <#items as t>
            <div class='section' id='table-${t.tableName}'>
                <div class='table-header'>
                    <div class='table-info'>
                        <h3><i class='fas fa-table'></i> ${t.tableName}</h3>
                        <div class='table-description'>
                            <i class='fas fa-info-circle'></i> ${t.remarks!''}
                        </div>
                    </div>
                    <a href='#top' class='back-to-top'>
                        <i class='fas fa-arrow-up'></i> 返回顶部
                    </a>
                </div>

                <div class='section-title'>
                    <i class='fas fa-columns'></i> 数据列
                </div>
                <div class='table-container'>
                    <table class='column-table'>
                        <thead>
                        <tr>
                            <th style='width:60px;'>序号</th>
                            <th>名称</th>
                            <th>数据类型</th>
                            <th>小数位</th>
                            <th>允许空值</th>
                            <th>主键</th>
                            <th>默认值</th>
                            <th>说明</th>
                        </tr>
                        </thead>
                        <tbody>
                        <#list t.columns>
                            <#items as c>
                                <tr>
                                    <td>${c?index+1}</td>
                                    <td>${c.columnName!''}</td>
                                    <td>${c.columnType!''}</td>
                                    <td>${c.decimalDigits!'0'}</td>
                                    <td>
                                        <#if c.nullable?? && c.nullable == 'Y'>
                                            <span class='badge badge-yes'>是</span>
                                        <#else>
                                            <span class='badge badge-no'>否</span>
                                        </#if>
                                    </td>
                                    <td>
                                        <#if c.primaryKey?? && c.primaryKey == '是'>
                                            <span class='badge badge-pk'>PK</span>
                                        <#else>
                                            -
                                        </#if>
                                    </td>
                                    <td>
                                        <#if c.columnDef?? && c.columnDef != ''>
                                            <span class='badge badge-null'>${c.columnDef}</span>
                                        <#else>
                                            <span style='color: var(--gray-color);'>-</span>
                                        </#if>
                                    </td>
                                    <td>${c.remarks!''}</td>
                                </tr>
                            </#items>
                        </#list>
                        </tbody>
                    </table>
                </div>
            </div>
        </#items>
    </#list>

    <!-- Footer -->
    <footer>
        <div class='footer-content'>
            <#if (organization)??>
                <div class='footer-info'>
                    <i class='fas fa-building'></i>
                    <div>
                        <#if (organizationUrl)??>
                            <a href="${organizationUrl}">${organization}</a>
                        <#else>
                            ${organization}
                        </#if>
                    </div>
                </div>
            </#if>
            <div style='margin-top: 20px; font-size: 0.9rem; opacity: 0.8;'>
                文档生成时间: ${.now?string('yyyy-MM-dd HH:mm:ss')}
            </div>
        </div>
    </footer>
</div>

<!-- 浮动返回顶部按钮 -->
<a href="#top" class="floating-top-btn" id="floatingTopBtn">
    <i class="fas fa-arrow-up"></i>
</a>

<script>
    // 平滑滚动到锚点
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const href = this.getAttribute('href');
            if (href === '#') return;

            e.preventDefault();
            const targetElement = document.querySelector(href);
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 20,
                    behavior: 'smooth'
                });

                // 添加临时高亮效果
                if (href !== '#top') {
                    targetElement.style.backgroundColor = 'var(--primary-light)';
                    setTimeout(() => {
                        targetElement.style.backgroundColor = '';
                    }, 1000);
                }
            }
        });
    });

    // 显示/隐藏浮动返回顶部按钮
    const floatingBtn = document.getElementById('floatingTopBtn');

    window.addEventListener('scroll', function() {
        if (window.pageYOffset > 300) {
            floatingBtn.classList.add('visible');
        } else {
            floatingBtn.classList.remove('visible');
        }
    });

    // 高亮当前查看的表（Intersection Observer）
    const observerOptions = {
        root: null,
        rootMargin: '-100px 0px -100px 0px',
        threshold: 0.1
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // 移除之前的高亮
                document.querySelectorAll('.section').forEach(section => {
                    section.style.boxShadow = 'none';
                });

                // 高亮当前表
                entry.target.style.boxShadow = '0 0 0 3px var(--primary-color)';

                // 3秒后移除高亮
                setTimeout(() => {
                    entry.target.style.boxShadow = 'none';
                }, 3000);
            }
        });
    }, observerOptions);

    // 观察所有表区域
    document.querySelectorAll('.section[id^="table-"]').forEach(section => {
        observer.observe(section);
    });

    // 添加打印样式
    window.addEventListener('beforeprint', () => {
        floatingBtn.style.display = 'none';
    });

    window.addEventListener('afterprint', () => {
        floatingBtn.style.display = '';
    });

    // 页面加载时滚动到顶部
    window.scrollTo(0, 0);
</script>
</body>
</html>