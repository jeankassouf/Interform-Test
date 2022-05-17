using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using events.Data;
using events.Models;
using Microsoft.AspNetCore.Http;
using System.IO;

namespace events.Controllers
{
    public class EventFilesController : Controller
    {
        private readonly ApplicationDbContext _context;

        public EventFilesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: EventFiles
        public async Task<IActionResult> Index()
        {
            var applicationDbContext = _context.EventFile.Include(e => e.Event);
            return View(await applicationDbContext.ToListAsync());
        }

        // GET: EventFiles/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var eventFile = await _context.EventFile
                .Include(e => e.Event)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (eventFile == null)
            {
                return NotFound();
            }

            return View(eventFile);
        }

        // GET: EventFiles/Create
        public IActionResult Create()
        {
            ViewData["EventId"] = new SelectList(_context.Event, "Id", "Title");
            return View();
        }

        // POST: EventFiles/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(List<IFormFile> eventFiles, Int32 EventId)
        {
            foreach (var eventFile in eventFiles)
            {
                var basePath = Path.Combine(Directory.GetCurrentDirectory() + "\\wwwroot\\Files\\");
                bool basePathExist = System.IO.Directory.Exists(basePath);
                if (!basePathExist) Directory.CreateDirectory(basePath);
                var fileName = Path.GetFileNameWithoutExtension(eventFile.FileName) + "-" + EventId;
                var extension = Path.GetExtension(eventFile.FileName);
                var filePath = Path.Combine(basePath, fileName+extension);
                EventFile model = new EventFile();
                switch (extension.ToLower())
                {
                    case ".jpeg":
                        model.Type = "Image";
                        break;
                    case ".png":
                        model.Type = "Image";
                        break;
                    case ".mp4":
                        model.Type = "Video";
                        break;
                    case ".pdf":
                        model.Type = "Document";
                        break;
                    case ".csv":
                        model.Type = "Document";
                        break;
                    default:
                        break;
                }
                model.EventId = EventId;
                model.Path = filePath;
                model.Name = fileName+extension;
                if (model.Type != null)
                {
                    if (!System.IO.File.Exists(filePath))
                    {
                        _context.Add(model);
                        await _context.SaveChangesAsync();

                        using (var stream = new FileStream(filePath, FileMode.Create))
                        {
                            await eventFile.CopyToAsync(stream);
                        }
                    }

                }
            }
            return RedirectToAction("Details", "Events", new { id = EventId });

        }

        // GET: EventFiles/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var eventFile = await _context.EventFile.FindAsync(id);
            if (eventFile == null)
            {
                return NotFound();
            }
            ViewData["EventId"] = new SelectList(_context.Event, "Id", "Title", eventFile.EventId);
            return View(eventFile);
        }

        // POST: EventFiles/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,EventId,Name,Path,Type")] EventFile eventFile)
        {
            if (id != eventFile.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(eventFile);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!EventFileExists(eventFile.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["EventId"] = new SelectList(_context.Event, "Id", "Title", eventFile.EventId);
            return View(eventFile);
        }
        // POST: EventFiles/Delete/5
        [Route("/EventFiles/Delete/{id}")]
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var eventFile = await _context.EventFile.FindAsync(id);
            _context.EventFile.Remove(eventFile);
            await _context.SaveChangesAsync();
            if (System.IO.File.Exists(eventFile.Path))
            {
                System.IO.File.Delete(eventFile.Path);
            }
            return RedirectToAction("Details", "Events", new { id = eventFile.EventId });
        }
        public async Task<IActionResult> Download(string filename)
        {
            if (filename == null)
                return Content("filename is not availble");
            
            var path = Path.Combine(Directory.GetCurrentDirectory() + "\\wwwroot\\Files\\", filename);

            var memory = new MemoryStream();
            using (var stream = new FileStream(path, FileMode.Open))
            {
                await stream.CopyToAsync(memory);
            }
            memory.Position = 0;
            return File(memory, GetContentType(filename), Path.GetFileName(path));
        }
        private string GetContentType(string path)
        {
            var types = GetMimeTypes();
            var ext = Path.GetExtension(path).ToLowerInvariant();
            return types[ext];
        }
        private Dictionary<string, string> GetMimeTypes()
        {
            return new Dictionary<string, string>
                {
                    {".pdf", "application/pdf"},
                    {".png", "image/png"},
                    {".jpeg", "image/jpeg"},
                    {".csv", "text/csv"},
                    {".mp4", "video/mp4"}
                };
        }
        private bool EventFileExists(int id)
        {
            return _context.EventFile.Any(e => e.Id == id);
        }
    }
}
