import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import 'package:conciertos_app/l10n/generated/app_localizations.dart';

import '../../data/services/ticket_wallet_service.dart';

/// Tarjeta para guardar la entrada de un concierto (foto o PDF) únicamente
/// en el dispositivo. Nunca se envía al backend: así, aunque el servidor se
/// vea comprometido, no hay ninguna entrada que robar.
class TicketWalletCard extends StatefulWidget {
  final String concertId;

  const TicketWalletCard({super.key, required this.concertId});

  @override
  State<TicketWalletCard> createState() => _TicketWalletCardState();
}

class _TicketWalletCardState extends State<TicketWalletCard> {
  final TicketWalletService _service = TicketWalletService();
  final ImagePicker _picker = ImagePicker();

  File? _ticket;
  bool _loading = true;

  bool get _isImage {
    final path = _ticket?.path.toLowerCase() ?? '';
    return path.endsWith('.jpg') || path.endsWith('.jpeg') || path.endsWith('.png');
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ticket = await _service.getTicket(widget.concertId);
    if (!mounted) return;
    setState(() {
      _ticket = ticket;
      _loading = false;
    });
  }

  Future<void> _addPhoto() async {
    final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 95);
    if (image == null || !mounted) return;
    final extension = image.path.split('.').last;
    final saved = await _service.saveTicket(widget.concertId, File(image.path), extension);
    if (!mounted) return;
    setState(() => _ticket = saved);
  }

  Future<void> _addPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: false,
      withReadStream: false,
    );
    final path = result?.files.single.path;
    if (path == null || !mounted) return;
    final saved = await _service.saveTicket(widget.concertId, File(path), 'pdf');
    if (!mounted) return;
    setState(() => _ticket = saved);
  }

  Future<void> _viewTicket() async {
    final ticket = _ticket;
    if (ticket == null) return;
    if (_isImage) {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(12),
          child: InteractiveViewer(
            child: Image.file(ticket),
          ),
        ),
      );
    } else {
      await SharePlus.instance.share(ShareParams(files: [XFile(ticket.path)]));
    }
  }

  Future<void> _deleteTicket() async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.ticketWalletConfirmDeleteTitle),
        content: Text(l.ticketWalletConfirmDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.ticketWalletDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _service.deleteTicket(widget.concertId);
    if (!mounted) return;
    setState(() => _ticket = null);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (_loading) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.confirmation_number_outlined,
                  color: Color(0xFFE53935),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  l.ticketWalletTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Tooltip(
                  message: l.ticketWalletLocalBadge,
                  child: const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_ticket == null) ...[
              Text(
                l.ticketWalletEmptyDescription,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _addPhoto,
                      icon: const Icon(Icons.photo_outlined, size: 18),
                      label: Text(l.ticketWalletAddPhoto),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _addPdf,
                      icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                      label: Text(l.ticketWalletAddPdf),
                    ),
                  ),
                ],
              ),
            ] else ...[
              InkWell(
                onTap: _viewTicket,
                borderRadius: BorderRadius.circular(12),
                child: _isImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _ticket!,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.picture_as_pdf_outlined, color: Color(0xFFE53935)),
                            const SizedBox(width: 10),
                            Expanded(child: Text(l.ticketWalletPdfFile)),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _viewTicket,
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: Text(l.ticketWalletView),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _deleteTicket,
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    label: Text(l.ticketWalletDelete, style: const TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
